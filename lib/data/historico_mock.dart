const Map<int, double> _gastosMock = {
  1: 1350,
  2: 980,
  3: 1120,
  4: 870,
  5: 1040,
  6: 760,
  7: 910,
  8: 500,
  9: 640,
  10: 1180,
  11: 890,
  12: 1420,
};

const Map<int, double> _patrimonioMock = {
  1: 1800,
  2: 1800,
  3: 1900,
  4: 1900,
  5: 2000,
  6: 2000,
  7: 2100,
  8: 2100,
  9: 2200,
  10: 2200,
  11: 2300,
  12: 2300,
};

DateTime inicioDoMes(DateTime data) => DateTime(data.year, data.month);

bool ehMesMockado(DateTime mes, DateTime contaCriadaEm) =>
    inicioDoMes(mes).isBefore(inicioDoMes(contaCriadaEm));

double? gastoMockDoMes(DateTime mes, DateTime contaCriadaEm) {
  if (!ehMesMockado(mes, contaCriadaEm)) return null;
  return _gastosMock[mes.month];
}

double? patrimonioMockDoMes(DateTime mes, DateTime contaCriadaEm) {
  if (!ehMesMockado(mes, contaCriadaEm)) return null;
  return _patrimonioMock[mes.month];
}
