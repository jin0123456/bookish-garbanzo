#pragma once
#include "Material.h"
#include "SinglePhaseFluidProperties.h"

class ADComputeCustomHw : public Material
{
public:
  static InputParameters validParams();
  ADComputeCustomHw(const InputParameters & parameters);
protected:
  virtual void computeQpProperties() override;
  const VariableValue & _pressure;
  ADMaterialProperty<Real> & _Hw_cutom;
  ADMaterialProperty<Real> & _T_sat;
  const PostprocessorValue & _internal_pressure;
  const SinglePhaseFluidProperties & _fp;
};