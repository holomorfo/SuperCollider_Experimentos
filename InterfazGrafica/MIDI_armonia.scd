
(
var notes, on, off;
~doMayor=a=Armonia.new.init([60,64,67]);
~univ=UniversoTonal.new.init();

MIDIClient.init;
MIDIIn.connectAll;
~notas =Array.new(64);

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
	notes[num] = Synth(\default, [\freq, num.midicps,
		\amp, veloc * 0.00315]);
	"======================".postln;
	~notas.add(num).postln;
	~arm=Armonia.new.init(~notas);
	~arm.imprimirSencillo;
	~univ.gradoSecundarioActStr(~arm).postln;
	"---------------------".postln;
	~list=~univ.getEscAct.acordesPosibles(~arm);
	~list.do({arg el; el.postln});
	"---------------------".postln;
	"Vecotor tonal".postln;
	~univ.vectorPorcentajes(~arm.notasArmonia).postln;
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
	notes[num].release;
	~notas =Array.new(64);

});

q = { on.free; off.free; };
)

q.value;

