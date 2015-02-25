(
SynthDef(\campanas, {arg freq=333, amp=0.4, dur=2;
	var salida, env;
	env = EnvGen.ar(Env.perc(0.01, dur), doneAction:2);
	salida = amp*Mix.fill(15, {arg i; SinOsc.ar(freq+(freq.rand),0, 1/20)}) * env;
	salida = FreeVerb.ar(salida,room:0.2);
	Out.ar(0, salida!2);
}).add;
)
(
SynthDef(\Disto, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	envTim = SinOsc.kr(0.1,0,10,20);
	sin = SinOsc.ar(freq,0, amp*80).clip2(1);
	sin = FreeVerb.ar(sin,room:1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add;
SynthDef(\RingzImpulse, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = Impulse.ar(freq/50, 1);
	sin = Ringz.ar(sin, freq, 2);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add;
SynthDef(\Strings1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25,0.4)), -1,1,500,2000);
	osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp) }).distort * 0.2;
	eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction:2);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add
)
(
a=Pdef(\camp,
	Pbind(
	\instrument, \Strings1,
	\freq, Prand(([0,10,2,20,4,7,8,9,10,12]+60).midicps,inf),
	\dur,  Prand([1,0.5,0.5,0.1]/4,inf),
	\amp,  Prand([0.3,0.2,0.5,1,1],inf)
)
)
)
a.play;
Synth(\campanas, [\freq, 1000.rand])
