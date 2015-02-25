(
b = Buffer.alloc(s, 44100 * 2.0, 1); // 8 second mono buffer

SynthDef(\recBuf,{ arg out=0, bufnum=0;
	var in;
	in = AudioIn.ar(1);
	RecordBuf.ar(in, bufnum);
}).load(s);
// SynthDef(\playBuf, {| out = 0, bufnum = 0 |
// 	var sig;
// 	sig= PlayBuf.ar(1, bufnum, 20,loop: 1, doneAction:2);
// 	Out.ar(out,sig)
// }).load(s);


a = FloatArray.fill(44100 * 5.0,{|i| sin(i/30).round(0.4)});

// 5 seconds of noise
b = Buffer.loadCollection(s, a);
b.play;
b.plot;
{SinOsc.ar}.play

// test it
b.get(20000,{|msg| (msg == a[20000]).postln});
// play it
x = { PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 0) * 0.5 }.play;
b.free; x.free;

b.plot
b.play
a=b.loadToFloatArray(action: { arg array; a = array; {a.plot;}.defer; "done".postln;});
a[440]


b.getMsg(02)