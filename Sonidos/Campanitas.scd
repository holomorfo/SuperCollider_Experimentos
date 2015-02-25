(
SynthDef(\campanas, {arg freq=333, amp=0.4, dur=2;
	var salida, env;
	env = EnvGen.ar(Env.perc(0.01, dur), doneAction:2);
	salida = amp*Mix.fill(15, {arg i; SinOsc.ar(freq+(freq.rand),0, 1/20)}) * env;
	salida = FreeVerb.ar(salida,room:0.2);
	Out.ar(0, salida!2);
}).add;



a=Pbind(
	\instrument, \campanas,
	\freq, Prand(([0,1,2,3,4,5,6,7,8,9,10,11,12]+60).midicps,inf),
	\dur,  Prand([1,0.5,0.5]/4,inf),
	\amp,  Prand([0.3,0.2,0.5,1,1],inf)
);
a.play;
)

Synth(\campanas, [\freq, 1000.rand])
