final DateTime inicioDadosReais = DateTime(2026, 9);

const Map<String, double> _gastosMock = {
  '2026-1': 1350,
  '2026-2': 980,
  '2026-3': 1120,
  '2026-4': 870,
  '2026-5': 1040,
  '2026-6': 760,
  '2026-7': 910,
  '2026-8': 500,
};

const Map<String, double> _patrimonioMock = {
  '2026-1': 1800,
  '2026-2': 1800,
  '2026-3': 1900,
  '2026-4': 1900,
  '2026-5': 2000,
  '2026-6': 2000,
  '2026-7': 2100,
  '2026-8': 2100,
};

bool ehMesMockado(DateTime mes) =>
    DateTime(mes.year, mes.month).isBefore(inicioDadosReais);

double? gastoMockDoMes(DateTime mes) {
  if (!ehMesMockado(mes)) return null;
  return _gastosMock[_chave(mes)] ?? 0;
}

double? patrimonioMockDoMes(DateTime mes) {
  if (!ehMesMockado(mes)) return null;
  return _patrimonioMock[_chave(mes)] ?? 0;
}

String _chave(DateTime mes) => '${mes.year}-${mes.month}';
