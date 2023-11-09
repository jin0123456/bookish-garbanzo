#include "ADComputeCustomHw.h"

registerMooseObject("WorkerApp", ADComputeCustomHw);

InputParameters
ADComputeCustomHw::validParams()
{
  auto params = Material::validParams();
  params.addRequiredCoupledVar("pressure", "Fluid pressure (Pa)");
  params.addParam<PostprocessorName>("P", "Internal pressure");
  params.addRequiredParam<UserObjectName>("fp", "The name of the user object for fluid properties");
  return params;
}

ADComputeCustomHw::ADComputeCustomHw(const InputParameters & parameters)
  : Material(parameters),
    _pressure(coupledValue("pressure")),
    _Hw_cutom(declareADProperty<Real>("Hw_cutom")),
    _T_sat(declareADProperty<Real>("T_sat")),
    _internal_pressure(getPostprocessorValue("P")),
    _fp(getUserObject<SinglePhaseFluidProperties>("fp"))
{
}

void
ADComputeCustomHw::computeQpProperties()
{
  _Hw_cutom[_qp] = 1e6 * 0.000255443 * std::exp(4. * _internal_pressure/1e5/62.);
  _T_sat[_qp] = _fp.vaporTemperature(_pressure[_qp]);
}