import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/gasto.dart';
import 'financas_repository.dart';

class SupabaseFinancasRepository implements FinancasRepository {
  SupabaseFinancasRepository(this._client);

  final SupabaseClient _client;

  static const String _tabelaGastos = 'gastos';
  static const String _tabelaPerfis = 'profiles';

  static const String _sessaoExpirada =
      'Sua sessão expirou. Saia e entre de novo.';

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const FinancasFalha(_sessaoExpirada);
    return id;
  }

  @override
  Future<double> buscarSalario() {
    return _executar('carregar o salário', () async {
      final linha = await _client
          .from(_tabelaPerfis)
          .select('salario')
          .eq('id', _userId)
          .maybeSingle();

      if (linha == null) return 0.0;
      return double.tryParse('${linha['salario']}') ?? 0.0;
    });
  }

  @override
  Future<void> salvarSalario(double valor) {
    return _executar('salvar o salário', () async {
      await _client.from(_tabelaPerfis).upsert({
        'id': _userId,
        'salario': valor,
      });
    });
  }

  @override
  Future<List<Gasto>> listarGastos() {
    return _executar('carregar os gastos', () async {
      final linhas = await _client
          .from(_tabelaGastos)
          .select()
          .eq('user_id', _userId)
          .order('created_at', ascending: true);

      return linhas.map<Gasto>((linha) => Gasto.fromMap(linha)).toList();
    });
  }

  @override
  Future<Gasto> adicionarGasto({required String nome, required double preco}) {
    return _executar('salvar o gasto', () async {
      final linha = await _client
          .from(_tabelaGastos)
          .insert({'user_id': _userId, 'nome': nome, 'preco': preco})
          .select()
          .single();

      return Gasto.fromMap(linha);
    });
  }

  @override
  Future<Gasto> atualizarGasto(Gasto gasto) {
    final id = gasto.id;
    if (id == null) {
      return Future.error(const FinancasFalha('Esse gasto ainda não foi salvo.'));
    }

    return _executar('atualizar o gasto', () async {
      final linha = await _client
          .from(_tabelaGastos)
          .update({'nome': gasto.nome, 'preco': gasto.preco})
          .eq('id', id)
          .select()
          .single();

      return Gasto.fromMap(linha);
    });
  }

  @override
  Future<void> removerGasto(String id) {
    return _executar('excluir o gasto', () async {
      await _client.from(_tabelaGastos).delete().eq('id', id);
    });
  }

  @override
  void limpar() {}

  Future<T> _executar<T>(String acao, Future<T> Function() operacao) async {
    try {
      return await operacao();
    } on FinancasFalha {
      rethrow;
    } on PostgrestException catch (e) {
      debugPrint(
        'Zena+ Supabase [$acao] código=${e.code} mensagem=${e.message} '
        'detalhes=${e.details} dica=${e.hint}',
      );
      throw FinancasFalha(_traduzir(e, acao));
    } on AuthException catch (e) {
      debugPrint('Zena+ Supabase [$acao] auth: ${e.message}');
      throw const FinancasFalha(_sessaoExpirada);
    } catch (e) {
      debugPrint('Zena+ Supabase [$acao] erro: $e');
      throw FinancasFalha(
        'Não foi possível $acao. Verifique sua internet e tente de novo.',
      );
    }
  }

  String _traduzir(PostgrestException e, String acao) {
    final codigo = e.code ?? '';
    final msg = e.message.toLowerCase();

    final colunaInexistente = codigo == '42703' ||
        codigo == 'PGRST204' ||
        (msg.contains('column') &&
            (msg.contains('does not exist') || msg.contains('could not find')));
    if (colunaInexistente) {
      return 'Alguma coluna não existe no Supabase. O app espera '
          'gastos(id, user_id, nome, preco, created_at) e '
          'profiles(id, nome, salario). Confira com o script '
          'zena_supabase_setup.sql.';
    }

    if (codigo == '42P01' ||
        codigo == 'PGRST205' ||
        msg.contains('could not find the table') ||
        msg.contains('does not exist')) {
      return 'As tabelas "gastos" e "profiles" não foram encontradas no '
          'Supabase. Rode o script zena_supabase_setup.sql no SQL Editor '
          '(se acabou de rodar, aguarde alguns segundos).';
    }

    if (codigo == '42501' ||
        msg.contains('row-level security') ||
        msg.contains('permission denied')) {
      return 'O Supabase negou o acesso. Confira as policies (RLS) e os '
          'GRANTs do script zena_supabase_setup.sql.';
    }

    if (codigo == 'PGRST301' || msg.contains('jwt')) {
      return _sessaoExpirada;
    }

    if (codigo == 'PGRST116') {
      return 'Não encontramos esse gasto. Ele pode já ter sido removido.';
    }

    if (codigo == '23514' || codigo == '23502') {
      return 'Valor inválido: o nome não pode ficar vazio e o preço precisa '
          'ser maior que zero.';
    }

    return 'Não foi possível $acao. Tente de novo em instantes.';
  }
}
