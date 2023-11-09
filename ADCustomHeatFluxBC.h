#pragma once

#include "ADIntegratedBC.h"

/**
 * Boundary condition for custom heat flux where temperature and heat transfer coefficient are
 * given by material properties.
 */
class ADCustomHeatFluxBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();

  ADCustomHeatFluxBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  /// Far-field temperature variable
  const ADMaterialProperty<Real> & _T_sat;

  /// Convective heat transfer coefficient
  const ADMaterialProperty<Real> & _htc;
};