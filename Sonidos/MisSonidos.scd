// Me encantan
Server.default.makeGui;

play({ Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, PinkNoise.ar, 0) });

(
SynthDef("evol",
{|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk = 5, sus = 8, rel = 5, pan = 0|
    var e = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction:2);
    var i = BrownNoise.ar(0.0012);
    var z = Klank.ar(
        `[freqs, nil, rings],     // specs
        i                    // input
    );
    Out.ar(out, Pan2.ar(z*e, pan));
}).add;

a=Pbind(
\instrument, \evol
);

r = Routine{
    var sustain = 6, transition = 4, overlap = 5;
    var period = transition*2+sustain/overlap;
    0.5.wait;            // wait for the synthdef to be sent to the server
    inf.do {
        Synth("evol", [
            \atk, transition,
            \sus, sustain,
            \rel, transition,
            \pan, 1.0.rand2,
            \freqs, {6000.0.linrand+80}.dup(12),
            \rings, {0.1.rrand(3)}.dup(12)
        ]);
        period.wait;
    }
};
r.play;
a.play
)
r.stop
FreqScope.new
{SinOsc.ar(800,0,0.3)}.play

(
{var a,b;
Klank.ar(`[[SinOsc.kr(MouseX.kr(200,400).postln,0,200,500), 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007!2)) }.play;
)

{BPF.ar(BrownNoise.ar,2000,0.005)}.play

{CombN.ar(SoundIn.ar(),3,LFNoise1.kr(0.5,1,2),1)}.play

{SinOsc.ar(Array.fill(3,{rrand(400,1200)}),0,SinOsc.kr(Array.fill(3,{rrand(0.1,0.1)}),0,1/14,1/14))}.play


//// Loquisimo
(
SynthDef(\intr1,{arg ws=0.3,pdisp= 0.2,tdisp = 0.2,out=0;
	var entrada,salida,drama, pR,wsm,pdispm,tdispm;
	wsm = [0.1,4,\lin].asSpec.map(ws);
	pdispm = [0,5].asSpec.map(pdisp);
	tdispm = Lag.kr([0.004,5].asSpec.map(tdisp));
	entrada = SoundIn.ar([0,1]);
	pR = Amplitude.kr(Mix(entrada)*4 - 0.25) + 0.25;
	salida = PitchShift.ar(entrada,
		wsm,
		pR,
		pdispm,
		tdispm);
	Out.ar(out,salida)
	}
// we skip metadata
//	,metadata:(specs: (\ws:Spec.add(\ws,[0.1,2,\lin])),
//		specs: (Spec.add(\pdisp,[0,5,\lin])),
//		specs: (Spec.add(\tdisp,[0.004,5,\lin]))
//		)
	).add;
~sin = Synth(\intr1);
)

s.scope
thisProcess.platform.recordingsDir
Server.local.makeGui;
Server.internal.makeGui; 