#include "ADCustomHeatFluxBC.h"

registerMooseObject("WorkerApp", ADCustomHeatFluxBC);

InputParameters
ADCustomHeatFluxBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addClassDescription(
      "Custom heat transfer boundary condition with temperature and heat "
      "transfer coefficent given by material properties.");
  params.addRequiredParam<MaterialPropertyName>("T_sat",
                                                "Material property for saturation temperature");
  params.addRequiredParam<MaterialPropertyName>("heat_transfer_coefficient",
                                                "Material property for heat transfer coefficient");
  return params;
}

ADCustomHeatFluxBC::ADCustomHeatFluxBC(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    _T_sat(getADMaterialProperty<Real>("T_sat")),
    _htc(getADMaterialProperty<Real>("heat_transfer_coefficient"))
{
}

ADReal
ADCustomHeatFluxBC::computeQpResidual()
{
  return -_test[_i][_qp] * _htc[_qp] * std::pow((_u[_qp] - _T_sat[_qp]), 4.);
}