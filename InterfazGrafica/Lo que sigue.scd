//
//MIDI IN

// YA_GUI elegir tonalidad

// GUI imprimir información acorde

// Imprimir Acorde String
// Imprimir coordenada tonal String
// Imprimir vector de Tonalidad

// Implementar Distancia Edit Acordes
// Implementar probabilidad de acordes


//===============================
// GUI

(
~univ = UniversoTonal.new.init();
~nombres=["c","c#","d","d#","e","f","f#","g","g#","a","a#","b"];
~tonalidadID =0 ;
~tonGUI = Window.new("Tonalidades", Rect(0,100,700,200));
~tonGUI.view.decorator = FlowLayout(~tonGUI.view.bounds);
~tonGUI.view.background = Color(0.6,0.8,0.8);

~tonalidadesM= Array.new(200);
for(0,12-1,{arg i;
	~tonalidadesM.add( Button(~tonGUI, Rect(20, 20, 25, 25))
		.states_([
			[""++~nombres[i]++"M", Color.black, Color.white],
			//[~instsStr.at(i), Color.white, Color.blue],
		])
		.action_({ arg butt, cosa;
			var id;
			id=i;
			"Identificador".postln;
			i.postln;
			"Tonalidad ID, valor".postln;
			butt.value.postln;
			~tonalidadID = i;
			~univ.setEscalaAct(i,"M");
			~univ.imprimirEscAct();
			//~tonMay.at(id).states_([]);
	}));
});

~tonalidadesMen= Array.new(200);
for(0,12-1,{arg i;
	~tonalidadesMen.add( Button(~tonGUI, Rect(20, 20, 25, 25))
		.states_([
			[""++~nombres[i]++"m", Color.black, Color.white],
			//[~instsStr.at(i), Color.white, Color.blue],
		])
		.action_({ arg butt, cosa;
			var id;
			id=i;
			"Identificador".postln;
			i.postln;
			"Tonalidad ID, valor".postln;
			butt.value.postln;
			~tonalidadID = i;
			~univ.setEscalaAct(i,"m");
			~univ.imprimirEscAct();
			//~tonMay.at(id).states_([]);
	}));
});

// ~txt = TextField(~tonGUI, Rect(10, 10, 150, 100));
// ~txt.string = "Acorde";
// ~txt.font = Font("Helvetica", 30);
// ~txt.action = {arg field; field.value.postln; };
~tonGUI.front;
)



//==================================
// MIDI
(
var notes, on, off;
MIDIClient.init;
MIDIIn.connectAll;
~notas =Array.new(64);

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
	notes[num] = Synth(\default, [\freq, num.midicps,
		\amp, veloc * 0.00315]);

	~notas.add(num);
	~arm=Armonia.new.init(~notas);
	~arm.imprimirSencillo;
	~univ.gradoSecundarioActStr(~arm).postln;
//	~txt.string = ""++~univ.gradoSecundarioActStr(~arm);};

});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
	notes[num].release;
	~notas =Array.new(64);

});

q = { on.free; off.free; };
)

q.value;
