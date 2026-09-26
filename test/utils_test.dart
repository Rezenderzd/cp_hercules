import 'package:flutter_test/flutter_test.dart';

import 'package:cp4_hercules/core/utils/nome_utils.dart';
import 'package:cp4_hercules/core/utils/saudacao.dart';

void main() {
  group('primeiroNome', () {
    test('pega só o primeiro nome com inicial maiúscula', () {
      expect(primeiroNome('fernando caires silva'), 'Fernando');
      expect(primeiroNome('  GUILHERME  Martins '), 'Guilherme');
      expect(primeiroNome('JOÃO PEDRO'), 'João');
    });

    test('retorna null quando não há nome', () {
      expect(primeiroNome(null), isNull);
      expect(primeiroNome('   '), isNull);
    });
  });

  group('nomeDoEmail', () {
    test('usa a parte inicial do e-mail', () {
      expect(nomeDoEmail('ana.silva@email.com'), 'Ana');
      expect(nomeDoEmail('raphael_99@email.com'), 'Raphael');
      expect(nomeDoEmail('MARIA@email.com'), 'Maria');
    });

    test('retorna null quando só há números ou nada', () {
      expect(nomeDoEmail('123@email.com'), isNull);
      expect(nomeDoEmail(''), isNull);
      expect(nomeDoEmail(null), isNull);
    });
  });

  group('saudacao', () {
    test('muda conforme o horário', () {
      expect(saudacao(DateTime(2026, 9, 19, 5)), 'Bom dia');
      expect(saudacao(DateTime(2026, 9, 19, 11, 59)), 'Bom dia');
      expect(saudacao(DateTime(2026, 9, 19, 12)), 'Boa tarde');
      expect(saudacao(DateTime(2026, 9, 19, 17, 59)), 'Boa tarde');
      expect(saudacao(DateTime(2026, 9, 19, 18)), 'Boa noite');
      expect(saudacao(DateTime(2026, 9, 19, 3)), 'Boa noite');
    });
  });
}
