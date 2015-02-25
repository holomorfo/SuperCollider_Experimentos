//Armstrong @ Dada X (18 Diciembre 2014)

//Arrancar ProxySpace

p = ProxySpace.push(s.boot)

p.fadeTime = 5

//En la impro se ejecutó el código activando primero los micros de Itze y Michele, después los graves y de ahí los que dicen Bass y Ritmo, después en ocasiones el Predrone y el Droneintro. Kutsi no se ejecutó. Se perdieron de una impro brutal!!

/////////////////Micrófonos

~micromich.play
~microitze.play

~micromich = {Limiter.ar (SoundIn.ar ([1], 0.9).dup)}

(
~microitze = {Limiter.ar (
	CombC. ar (SoundIn.ar ([0], 0.9).dup,
		Rand (0.2,0.0025), Rand (0.2,0.0050), Rand (-10, 5))
)}
)

~micromich.stop
~microitze.stop

////////Synth 1: Drone (fusilado del ejemplo de Klank)

(
SynthDef ( \droneintro, {|out1=0, frecs=#[0,0,0,0,0,0,0,0,0,0,0,0],  rings=#[0,0,0,0,0,0,0,0,0,0,0,0], ataq1=5, sus1=8, rele1=5, pan1=0, frec1 = 600, frec2 = 400|
	var envo1, source1, klank1;
	envo1 = EnvGen.kr (Env.linen (ataq1, sus1, rele1, 1, 4), doneAction:2);
	source1 = BrownNoise.ar (0.0012) + LFTri.ar ([frec1, frec2], 0, 0.001);
	klank1 = Klank.ar (`[frecs, nil, rings], source1);
	Out.ar (out1, Pan2.ar (Limiter.ar (envo1 * klank1), pan1) * 0.2)
}).add
)

////Patrón del drone

(
~droneintropat = Routine{
	var sustain = 6, transition = 4, overlap = 5;
	var period = transition*2+sustain/overlap;
	0.5.wait;
	inf.do {
		Synth(\droneintro, [
			\atk, transition,
			\sus, sustain,
			\rel, transition,
			\pan1, 1.0.rand2,
			\frecs, {2000.0.linrand+80}.dup(12),
			\frec1, {6000.0.linrand+100},
			\frec2, {4000.0.linrand+50},
			\rings, {0.1.rrand(3)}.dup(12)
		]);
		period.wait;
}}
)

~droneintropat.release

////////////////////// Synth 2: Drone 2.

~drone2.play

(
~drone2 = {Limiter.ar( (Resonz.ar (
	Pan2.ar (SinOsc.ar (Rand (150,400), 0, 0.5), LFNoise2.kr (3)) +
	BPF.ar (Impulse.ar ([Rand (200,400), Rand (200,500)], 0.5pi, 0.7), 200, 3) +
	BPF.ar (Saw.ar ([Rand (600,1700), Rand (800,1800)], 0.5), 900, 0.5) +
	Pan2.ar (LFNoise0.ar (Rand (200,500), 0.1), LFNoise0.kr (3)),
	Rand (500,1500), Rand (0.5,5)
	) // termina Resonz
	) * 0.5 //termina Limiter
)}
)

~drone2.release

///////////////////Synth 3: Kutsi (no fue ejecutado)

(
SynthDef (\kutsi, {|nota=230, note=260, phase1=0.5pi, phase2=2.0pi, rele1=3, lfo=5, amp1=0.5, amp2=0.5|
	var ond, envol;
	ond = DelayC.ar ( (LPF.ar (
		(SinOsc.ar ([note,nota] + SinOsc.ar ([nota,note], [phase2,phase1], [amp2,amp1]), [phase1,phase2], [amp1,amp2])),
		1600)),
		0.2, 0.002, 0.7); //parámetros de DelayC
	envol = EnvGen.kr (Env.perc (2, rele1, curve:2), doneAction:2);
	Out.ar (0, Pan2.ar (ond * envol, LFNoise0.kr (lfo)))
}).add
)

(
~acalycanto = Pdef (\luna,
	Pbind (\instrument, \kutsi,
		\nota, Pseq  ([52,54,54,57,59,57,61,59,57,56,54,52,50].midicps, inf),
		\note, Pseq ([68,71,69,73,74,73,76,74,73,71,69,68,66].midicps, inf),
		\dur,   Pseq([ 3, 3, 6, 3, 3, 6, 3, 3, 3, 6, 3, 3, 8], inf),
		\rele1, Pseq([ 4, 4, 7, 4, 4, 8, 4, 6, 4, 7, 4, 4,10], inf),
		\phase1, Prand ([1.0pi, 2.0pi], inf),
		\phase2, Prand ([0.5pi, 1.5pi], inf),
		\lfo, Prand ([20, 40, 10, 50], inf),
		\amp1, Prand ([0.05, 0.1, 0.2], inf),
		\amp2, Prand ([0.1, 0.05, 0.2], inf)
))
)

~acalycanto.release

//////////////////////////Synth 4. Ritmo 1.

~ritmo1.play

(
~ritmo1 = { Limiter.ar (
	SinOsc.ar ([Rand (200,600), Rand (200,500)],
		LFTri.kr ([Rand (2,5), Rand (2,8)]),
		LFNoise0.kr ([Rand (4,10), Rand (2,7)])) +
	Resonz.ar (Pulse.ar ([100,400], Impulse.kr ([0.05,0.05])),
		Rand (120,400), Rand (0.1,4)) //parámetros de Resonz
	) //fin de Limiter
	* Rand (0.05,0.1)}
)

~ritmo1.release

//////////////////////////Synth 5. Bass 2.

~bass2.play

(
~bass2 = { SinOsc.ar ([Rand (120,250), Rand (180,320)],
	LFNoise2.kr (Rand (10,20)), 0.2) *
	FSinOsc.ar ([Rand (200,400), Rand (250,450)], 0, 0.1)
}
)

~bass2.release

//////////////////////////////Synth 6. Bass 1.

~bass1.play

(
~bass1 = { SinOsc.ar ([Rand (95,200), Rand (100,220)],
	LFNoise2.kr ([Rand (0,5), Rand (10,20)]), 0.1)}
)

~bass1.release

/////////////////////////////Synth 7. Pre-Drone.

~predrone.play

(
~predrone = {Array.fill (2, { Pan2.ar
	(Limiter.ar
		(CombN.ar (SinOsc.ar (
			PinkNoise.kr (0.2) + LFTri.kr (710, 0, 0.7),
			SinOsc.kr ([122,333], 1.5pi, 0.5), 0.5) *
			LFNoise1.ar (600, 0.5),
			0.02, Rand (0.0015,0.0045), 1), //termina CombN
			0.1))}) * 0.3 *
	EnvGen.kr (Env.perc (5,20, curve:0), doneAction:2)
}
)

///////////////////////////Liberar todo.

p.release

////////////////////////////////////////////////////////