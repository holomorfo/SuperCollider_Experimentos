MIDIIn.connect;    // init for one port midi interface
s.scope
s.options.device_("ASIO : ASIO4ALL v2");

/*
Sintetizador MIDI, crear librería.
*/
(
~sinteNum = 0;
~notas = Array.fill(88,0);
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
MIDIIn.removeFuncFrom(\noteOff, ~noteOff);
MIDIIn.removeFuncFrom(\control, ~control);
MIDIIn.connect;    // init for one port midi interface
MIDIIn.connect(8, MIDIClient.sources.at(8)); 	// init for one port Yoke
//MIDIIn.connect(2, MIDIClient.sources.at(2)); 	// init for one port Yoke
~noteOff = { arg src, chan, num, vel;
	"NoteOff".postln;
	[chan,num,vel].postln;
	~notas.at(num).set(\gate, 0);
};
~noteOn = { arg src, chan, num, vel;
	"NoteOn".postln;
	[chan,num,vel].postln;
	f = Date.getDate;
	t =f.bootSeconds.postln;
	//~notas.add(num);
	~tiempos.add(t);
	~notas.put(num,Synth.new(~sintes.at(~sinteNum).name,
		[\freq, num.midicps,\amp, vel/127]));
};
~control = { arg src, chan, num, val;
	"CC".postln;
	[chan,num,val].postln;
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);
MIDIIn.addFuncTo(\noteOff, ~noteOff);
MIDIIn.addFuncTo(\control, ~control);



///////////////////////////////////////////////
// Instrumentos
~sintes =  Array.new(20);


~sintes.add(SynthDef(\Disto, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	envTim = SinOsc.kr(0.1,0,10,20);
	sin = SinOsc.ar(freq,0, amp*80).clip2(1);
	sin = FreeVerb.ar(sin,room:1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\SinDistFold, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=2, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	envTim = SinOsc.kr(0.1,0,10,20);
	sin =SinOsc.ar(freq, 0, envTim).wrap2(1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\KlankPink, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = PinkNoise.ar(0.03);
	sin = Klank.ar(`[ (1..13)*freq, 1/(1..13), nil ], sin);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\Formlet, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = Impulse.ar(freq/10);
	sin = Formlet.ar(sin,freq , 0.01, 0.1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\RingzImpulse, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = Impulse.ar(freq/50, 1);
	sin = Ringz.ar(sin, freq, 2);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\Dust2, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = Dust2.ar(freq, 1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\LFNoise2, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin =LFNoise2.ar(freq, 1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\LFNoise1, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin =LFNoise1.ar(freq, 1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\LFNoise0, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin =LFNoise0.ar(freq, 1);
	envTim = SinOsc.kr(freq/1000,0,100,freq);
	sin = BPF.ar(sin,envTim );
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\LFCpNoiseCUIDADO, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin =LFClipNoise.ar(freq,1);
	envTim = SinOsc.kr(freq/1000,0,100,freq);
	sin = BPF.ar(sin,envTim );

	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\KlangPerc, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.perc(0.05, 1, 1, -4), gate,
		doneAction: 2);
	sin =Klang.ar(`[ {exprand(freq, 2000*amp)}.dup(10), nil, nil ], 0.6, 0)*0.3;
	sin = Pan2.ar(sin, pan)*env*0.3;
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\KlangLento, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.5, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin =Klang.ar(`[ {exprand(freq, 2000*amp)}.dup(10), nil, nil ], 0.6, 0)*0.3;
	sin = Pan2.ar(sin, pan)*env*0.3;
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\ADSR_Pulse1, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.2, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = Pulse.ar(freq,0.5,0.1);
	envTim = XLine.kr(8000,freq,5);
	sin = RLPF.ar(sin,envTim, 0.05) *env;
	sin = Pan2.ar(sin, pan);
	Out.ar(out, sin);
}).add);


~sintes.add(SynthDef(\HiHat1, {|amp=0.3,freq=200,pan=0| var osc, env, noise, out;
	osc = BPF.ar(WhiteNoise.ar(),freq,50);
	env = Line.ar(1, 0, 0.1,amp,doneAction:2);
	out = osc * env;
	Out.ar(0,Pan2.ar(out, pan)
	)
}).add);

~sintes.add(SynthDef( \PulsoSin, {|freq=200,amp = 0.5,pan =0|var osc, env, output;
	osc = SinOsc.ar(freq);
	env = Line.ar(1, 0, 0.5,amp, doneAction: 2);
	output = osc * env;
	Out.ar(0,Pan2.ar(output, pan=0)
	)
}).add);


// Instrumento tipo piano
~sintes.add(SynthDef(\PianoElect, { arg  freq=440, amp=0.7, oct=0,pan=0, gate=1;
	var out,env, envTim;
	env =  Linen.kr(gate, 0.01, 0.7, 0.3, 2,doneAction:2);
	envTim = XLine.kr(5000,freq,0.5);
	out = LPF.ar(LFSaw.ar(freq*pow(2,oct)),envTim ) *env;
	Out.ar(0, Pan2.ar(out, pan, amp));
}).add);

~sintes.add(SynthDef(\Strings1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25,0.4)), -1,1,500,2000);
	osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp) }).distort * 0.2;
	eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction:2);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add);

~sintes.add(SynthDef(\ADSR_Sin, {arg out = 0, freq, amp = 0.2, gate = 1, pan=0, a=0.2, d=0.1, s=0.9, r=0.5;
	var env, sin;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = SinOsc.ar(freq, mul:env);
	sin = Pan2.ar(sin, pan);
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\ADSR_Tri, {arg out = 0, freq, amp = 0.2, gate = 1, pan=0, a=0.2, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin =  LFTri.ar(freq, mul:env);
	envTim = XLine.kr(freq,20000,a);
	sin = LPF.ar(sin,envTim );
	sin = Pan2.ar(sin, pan);
	Out.ar(out, sin);
}).add);

~sintes.add(SynthDef(\ADSR_Saw, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.2, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	sin = Saw.ar(freq, mul:env);
	//envTim = XLine.kr(5000,freq,0.5);
	envTim = XLine.kr(freq,20000,a);
	sin = LPF.ar(sin,envTim );
	sin = Pan2.ar(sin, pan);
	Out.ar(out, sin);
}).add);


///////////////////////////////////////777
// GUI

~tonGUI = Window.new("Holomorfo", Rect(500,200,700,300));
~tonGUI.view.decorator = FlowLayout(~tonGUI.view.bounds);
~tonGUI.view.background = Color(0.6,0.8,0.8);
~tonMay= Array.new(200);
for(0,~sintes.size-1,{arg i;
	~tonMay.add( Button(~tonGUI, Rect(20, 20, 100, 50))
		.states_([
			[""++~sintes.at(i).name, Color.white, Color.black],
			//[~instsStr.at(i), Color.white, Color.blue],
		])
		.action_({ arg butt, cosa;
			var id;
			id=i;
			~sinteNum = id;
			"Identificador".postln;
			i.postln;
			"Boton, valor".postln;
			butt.value.postln;
			//~tonMay.at(id).states_([]);
	}));
});
~tonGUI.front;

)

s.meter


SynthDef(\disto, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25,0.4)), -1,1,500,2000);
	osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp) }).distort * 0.2;
	eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction:2);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
});

(
{var in;
	in= SinOsc.ar(80,0, MouseX.kr(0.1,80,1)).clip2(1) * 0.2;
	in = FreeVerb.ar(in,room:1);
	in = in!2
}.play;
)
FreeVerb.ar()
{!2 }.scope(1);

