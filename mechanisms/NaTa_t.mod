:Reference :Colbert and Pan 2002

NEURON	{
	SUFFIX NaTa_t
	USEION na READ ena WRITE ina
	RANGE gNaTa_tbar, gNaTa_t, ina, vtha, vthi,qa,qi, mtau_scale, htau_scale
}

UNITS	{
	(S) = (siemens)
	(mV) = (millivolt)
	(mA) = (milliamp)
}

PARAMETER	{
	gNaTa_tbar = 1.0 (S/cm2)
	vtha = -38 (mV) : v 1/2 for activation (m)
	vthi = -66 (mV) : v 1/2 for inactivation (h)
	qa = 6 (1) : activation slope
	qi = 6 (1) : inactivation slope	
    mtau_scale = 1 (1) : scaling on activation time constant
    htau_scale = 1 (1) : scaling on inactivation time constant
}

ASSIGNED	{
	v	(mV)
	ena	(mV)
	ina	(mA/cm2)
	gNaTa_t	(S/cm2)
	mInf
	mTau
	mAlpha
	mBeta
	hInf
	hTau
	hAlpha
	hBeta
}

STATE	{
	m
	h
}

BREAKPOINT	{
	SOLVE states METHOD cnexp
	gNaTa_t = gNaTa_tbar*m*m*m*h
	ina = gNaTa_t*(v-ena)
}

DERIVATIVE states	{
	rates()
	m' = (mInf-m)/mTau
	h' = (hInf-h)/hTau
}

INITIAL{
	rates()
	m = mInf
	h = hInf
}

PROCEDURE rates(){
  LOCAL qt
  :qt = 2.3^((34-21)/10)
  qt = 2.3^((celsius-21)/10)	
  UNITSOFF
    if(v == -38){
    	v = v+0.0001
    }
		mAlpha = (0.182 * (v - vtha))/(1-(exp(-(v- vtha)/qa)))
		mBeta  = (0.124 * (-v +vtha))/(1-(exp(-(-v +vtha)/qa)))
		mTau = (mtau_scale/(mAlpha + mBeta))/qt
		mInf = mAlpha/(mAlpha + mBeta)

    if(v == -66){
      v = v + 0.0001
    }

		hAlpha = (-0.015 * (v- vthi))/(1-(exp((v- vthi)/qi)))
		hBeta  = (-0.015 * (-v +vthi))/(1-(exp((-v +vthi)/qi)))
		hTau = (htau_scale/(hAlpha + hBeta))/qt
		hInf = hAlpha/(hAlpha + hBeta)
	UNITSON
}