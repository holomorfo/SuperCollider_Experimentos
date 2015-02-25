/*
Prototipo Presentación CCD
Composición Interactiva
versión_0.3

Cristian Bañuelos
2014 abril 22
*/

//===== antes de bootear
Server.local.options.memSize = 32368;
Server.local.options.numBuffers  = 2048;


(
/////////////////////////////////////////////////////////
/// DEFINICIONES Sintetizadores INICIO
/////////////////////////////////////////////////////////


//======= cofig archivos de audio

~marim = Wavesets.from("/Users/rmm/Robeto_bck/Roberto Todo (parte)/correo/audio_loos/marimba_1mono.aif");
~marimbita = Buffer.read(s,"/Users/rmm/Robeto_bck/Roberto Todo (parte)/correo/audio_loos/marimba_1mono.aif");

~paja = Wavesets.from("/Users/rmm/Robeto_bck/Roberto Todo (parte)/correo/audio_loos/torito_2mono.aif");
~pajarito = Buffer.read(s,"/Users/rmm/Robeto_bck/Roberto Todo (parte)/correo/audio_loos/torito_2mono.aif");

~flws = Wavesets.from("/Users/rmm/sounds_r/correo/audio_loos/flautita1_mono.aiff");
~fl = Buffer.read(s,"/Users/rmm/sounds_r/correo/audio_loos/flautita1_mono.aiff");

//~pajaK = Wavesets.from("/Users/rmm/Documents/Doc_Rober_07-08/Instalaciones_2014/Zanate_de_luz/zanates1.wav");
~pajaritoKd = Buffer.read(s,"/Users/rmm/Documents/Doc_Rober_07-08/Instalaciones_2014/Zanate_de_luz/zanates1.wav");

~pajaritoKi = Buffer.read(s,"/Users/rmm/Documents/Doc_Rober_07-08/Instalaciones_2014/Zanate_de_luz/zanates1-2.wav");



~cinco = Pxrand([[~marimbita.bufnum,(~marim.maxima.size-15),~marim],[~pajarito.bufnum,(~paja.maxima.size-15),~paja],[~fl.bufnum,(~flws.maxima.size-15),~flws]],inf).asStream;



//============================== Sintes ===========================

//=====  Fabian

SynthDef(\resonancia,{arg out=0;
	var im,kl,salida,alt;
	im = Pulse.ar(0.1,mul:0.0001);
	alt = Lag.kr(\frec.kr(1.0),2);
	salida = DynKlank.ar(`[
		([25,37,43,60,64,69,74,79].midicps)*alt,
		nil,                             // amplitudes (default to 1.0)
		\res.kr([ 1.528461766243, 1.5527283191681, 1.9528163433075, 0.50381197929382, 1.5711230397224, 1.6935468554497, 0.20943180322647, 1.8102689266205])                // ring times
        ], Decay.ar(im, 0.003, ClipNoise.ar(0.01)));
	salida = FreeVerb.ar(salida*(\vol.kr(0.5)));
	DetectSilence.ar(salida,doneAction:2);
	salida = Pan2.ar(salida,\pan.kr(0.1));
	Out.ar(out,salida)
}).add;



//======================= mas zanates

SynthDef(\zan,{arg out=0,bufnum=0,tiempo=0.5,rate=1,gate=1;
	var samp,salida,afin,snd,z,trig;
	afin = Lag.kr(rate,3);
//	z = LFNoise1.kr(frf,BufFrames.ir(bufnum)/2,BufFrames.ir(bufnum)/2);
	samp = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum)*afin,/*startPos:z,*/ loop:1/*,trigger:trig*/);
	salida = CombN.ar(samp,3,Lag.kr(tiempo,3),2,0.3,samp);
	snd = LPF.ar(HPF.ar(salida,450),3500);
	salida = Pan2.ar(snd,\pan.kr(0.4));
	salida = salida *EnvGen.kr(Env.cutoff(2,1),gate,doneAction:2);
	Out.ar(out,salida)
}).add;

//====== Cabrzas

SynthDef(\Machine, {
	arg gain=0.02, heli=1.7, up=254.3;
	var source;
	source = DynKlank.ar(
		`[[60,100,120,200,300],[1,0.8,0.7,0.6,0.8],[1,1,1,1,1]],
		Decay.ar(WhiteNoise.ar(0.2), 0.003, ClipNoise.ar(0.01)),decayscale:0.2);
	source = RLPF.ar(source,Lag.kr(\filtro.kr(1000),5),heli)*\vol.kr(1);
	source = FreeVerb.ar(source,0.7);
	source = Pan2.ar(source,\pan.kr(0.1));
	Out.ar(0,source);
}).add;

//========== Cris
SynthDef(\SinDistFold, {arg out = 0, freq, amp = 0.5, gate = 1, pan=0, a=0.2, d=0.1, s=0.9, r=0.5;
	var env, sin,envTim;
	env = EnvGen.kr(Env.adsr(a, d, s, r, amp), gate,
		doneAction: 2);
	envTim = SinOsc.kr(0.1,0,5,10);
	sin =SinOsc.ar(freq, 0, envTim).wrap2(1);
	sin = Pan2.ar(sin, pan)*env;
	Out.ar(out, sin);
}).add;

//===== Edmar

SynthDef(\risset, {
	   arg  out, vol = 0.8,rate = 0.3, curv = -7, frecfund = 400, durA= 8, atk = 0.05;

	   var par, parfunc, finalenv, finalsig, pan;
	   par = Array.new(11);


	   parfunc={arg amp, durR, freqR, detune;
		   var env, sig, freqt;
		   freqt = frecfund*freqR;
		   sig = SinOsc.ar(freqt+detune);
		   env = EnvGen.kr(Env.perc(0.05, durA*durR, amp*0.1, -4),
		   doneAction:0);
		   par.add(sig*env)
		   };

		 parfunc.(1, 1, 0.56, 0);
		parfunc.(0.67, 0.9, 0.56, 1);
		parfunc.(1, 0.65, 0.92, 0);
		parfunc.(1.8, 0.55, 0.92, 1.7);
		parfunc.(2.67, 0.325, 1.19, 0);
		parfunc.(1.67, 0.35, 1.7, 0);
		parfunc.(1.46, 0.25, 2, 0);
		parfunc.(1.33, 0.2, 2.74, 0);
		parfunc.(1.33, 0.15, 3, 0);
		parfunc.(1, 0.1, 3.76, 0);
	   parfunc.(1.33, 0.075, 4.07, 0);

	   finalenv = EnvGen.kr(Env.perc(atk, durA, curve: curv),doneAction:2);
	   finalsig = Mix.new(par);

	   pan = Pan2.ar(finalsig*finalenv,LFNoise0.kr(SinOsc.kr(0.05).range(0.01,2)),rrand(0.1,0.3));
	   Out.ar(out,pan*vol)
	   }).add;

//==============================


//===========================


/////////////////////////////////////////////////////////
/// DEFINICIONES Sintetizadores FIN
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
/// DEFINICIONES Pbinds INICIO
/////////////////////////////////////////////////////////
~usrNum = Array.new(500);
~usrTmp = Array.new(500);
~usrPdefList = Array.new(500);
~bindsFuncL=  Array.new(500);
~posicion = Array.new(500);
~alturas== Array.new(500);
~volumenes= Array.new(500);
~ritmos= Array.new(500);
~paneos= Array.new(500);

/* Es muy importante poner el .asSymbol, por que si no
no se actualizan bien los Pdefs

Formato para agregar Pdefs

~bindsFuncL.add({arg id=1;
var idFunc;
for(0,~usrNum.size-1,{ arg i;
if((id==~usrNum.at(i)) ,{
idFunc =i;
});
});
Pdef((\nombre++"_"++id).asSymbol,
AQUI VA EL CODIGO
Usar como parámetros de control del usuario
Pdef({~ritmos.at(idFunc)})
Pdef({~alturas.at(idFunc)})
Pdef({~paneos.at(idFunc)})
Pdef({~volumenes.at(idFunc)})

*/

//=============== Pdef de referencia
// ~bindsFuncL.add({arg id=1;
// 	// Revisar que índice de usuario es
// 	var idFunc;
// 	for(0,~usrNum.size-1,{ arg i;
// 		if((id==~usrNum.at(i)) ,{
// 			idFunc =i;
// 		});
// 	});
// 	// Crear el Pdef a la medida, con los Pfunc
// 	Pdef((\cris++"_"++id).asSymbol,
// 		Pbind(
// 			\instrument, \campanas,
// 			\freq, Pbrown(30,70,Pfunc({7.rand})).midicps,
// 			\dur,  Prand([1,0.5,0.5],inf)/(Pfunc(
// 			{1*~ritmos.at(idFunc)})+1),
// 			\pan, (2*Pfunc({~paneos.at(idFunc)}))-1,
// 			\amp,  Prand([0.3,0.2,0.5,1,1],inf)
// 			*Pfunc({~volumenes.at(idFunc)})
// 	))
// });

//=========== van Pdefs
~bindsFuncL.add({arg id=1;
	// Revisar que índice de usuario es
	var idFunc;
	for(0,~usrNum.size-1,{ arg i;
		if((id==~usrNum.at(i)) ,{
			idFunc =i;
		});
	});
	// Crear el Pdef a la medida, con los Pfunc
	Pdef((\fabian++"_"++id).asSymbol,
		Pbind(
			\instrument, \resonancia,
			//	\frec, Pseq([1,2,3,4,5],inf),
			\frec, Pwhite(0.2, 2.0),
			\dur, Prand([0.2,0.4],inf)*Pfunc({~ritmos.at(idFunc)}),
			\res,Pfunc({[Array.rand(8,1,5.0)]}),
			\vol,Pwhite(0.5,1.2),
			\pan, (2*Pfunc({~paneos.at(idFunc)}))-1

			//	\freq, Pwhite(60, 72).midicps * 3
	))
});


//=== Roberto M

~bindsFuncL.add({arg id=1;
	// Revisar que índice de usuario es
	var idFunc;
	for(0,~usrNum.size-1,{ arg i;
		if((id==~usrNum.at(i)) ,{
			idFunc =i;
		});
	});
	// Crear el Pdef a la medida, con los Pfunc
	Pdef((\yo++"_"++id).asSymbol,
		Pmono(\zan,
	\bufnum,Pxrand([~pajaritoKd,~fl],inf),
	\rate,Pxrand([1.3,0.25,0.5],inf),
	\dur, Pseq([13,8,12,17],inf)*Pfunc({~ritmos.at(idFunc)}),
	\tiempo,Pxrand([0.02,0.5,1.5,2.3],inf),
	\pan, (2*Pfunc({~paneos.at(idFunc)}))-1
		)
	)
});

//=== Roberto Cabezas

~bindsFuncL.add({arg id=1;
	// Revisar que índice de usuario es
	var idFunc;
	for(0,~usrNum.size-1,{ arg i;
		if((id==~usrNum.at(i)) ,{
			idFunc =i;
		});
	});
	// Crear el Pdef a la medida, con los Pfunc
	Pdef((\cabezas++"_"++id).asSymbol,
		Pmono(
	\Machine,
	\heli,Prand([0.3,0.5,1],inf),
	\dur,0.2,
			\filtro, Pwhite(1000,3000)*0.2,
//	\gain,Pwhite(0.001,0.02),
	\pan,(2*Pfunc({~paneos.at(idFunc)}))-1,
	\vol, Pwhite(0.5,0.2)*Pfunc({~volumenes.at(idFunc)})
)
	)
});


//=== Cris

~bindsFuncL.add({arg id=1;
	// Revisar que índice de usuario es
	var idFunc;
	for(0,~usrNum.size-1,{ arg i;
		if((id==~usrNum.at(i)) ,{
			idFunc =i;
		});
	});
	// Crear el Pdef a la medida, con los Pfunc
	Pdef((\cris++"_"++id).asSymbol,
		Pbind(
			\instrument, \SinDistFold,
			\freq, Pbrown(30,70,Pfunc({7.rand})).midicps,
			\dur,  Prand([1,0.5,0.5],inf)/(Pfunc(
			{5*~ritmos.at(idFunc)})+1),
			\pan, (2*Pfunc({~paneos.at(idFunc)}))-1,
			\amp,  Prand([0.3,0.2,0.5,0.3,0.6]*0.2,inf)*Pfunc({~volumenes.at(idFunc)})
		)
	)
});

//==== Edmar

~bindsFuncL.add({arg id=1;
	// Revisar que índice de usuario es
	var idFunc;
	for(0,~usrNum.size-1,{ arg i;
		if((id==~usrNum.at(i)) ,{
			idFunc =i;
		});
	});
	// Crear el Pdef a la medida, con los Pfunc
	Pdef((\edmar++"_"++id).asSymbol,
		Pbind(
			\instrument,\risset,
			\frecfund,Pxrand(Array.rand(8,20,1000),inf),
			\atk, Pwhite(0.05,0.2),
			\dur,Prand([0.2,0.1],inf) *Pfunc({~ritmos.at(idFunc)}),
			\durA, Pwhite(0.1,2),
			\vol, Pfunc({~volumenes.at(idFunc)})
		)
	)
});




/////////////////////////////////////////////////////////
/// DEFINICIONES Pbinds FIN
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
/// ENTRADAS Osc INICIO
/////////////////////////////////////////////////////////
a=OSCdef('XY',{|x|
	var mag;
	// "_____________________".postln;
	// "Touch, sonido: ".postln;
	//x[0].postln; // ID
	// x[1].postln; // ID
	// x[2].postln; // valor x
	// x[3].postln; // valor y
	mag = sqrt((x[2]**2)+(x[3]**2));
	// "Velocidad".postln;
	// mag.postln;
	~revVelFunc.value(x[1],x[2],x[3]);
	~cambiarPaneo.value(x[1],x[2])
},"/XY");

b =OSCdef('knob_vol',{|x|
	// "_____________________".postln;
	// "Knob, volumen: ".post;
	//x[0].postln; // ID
	// x[1].postln; // ID
	// x[2].postln; // valor
	// Cambiar volumen
	~cambiarVolumen.value(x[1],x[2])
},"/knob_vol");

c =OSCdef('knob_rit',{|x|
	// "_____________________".postln;
	// "Knob, volumen: ".post;
	//x[0].postln; // ID
	// x[1].postln; // ID
	// x[2].postln; // valor
	// Cambiar volumen
	~cambiarRitmos.value(x[1],x[2])
},"/knob_rit");

/////////////////////////////////////////////////////////
/// ENTRADAS Osc FIN
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
/// Control de usuarios INICIO
/////////////////////////////////////////////////////////
~revVelFunc = {arg usr, px, py; // Num Usuario y posiciones nuevas
	var mag, agregar, fecha, tmp=0, indice, idFunc,px0,py0;
	fecha = Date.getDate;
	tmp =fecha.rawSeconds;  // SC 3.7
	agregar = true;
	for(0,~usrNum.size-1,{ arg i;
		// Si el usuario existe, modificar velocidad
		if(usr==~usrNum.at(i) ,{
			// Ya no se agrega
			agregar=false;
//			"Modificar usuario y sinte".postln;
			// Revisar si está activo
			if(~usrPdefList.at(i).isActive,{
				// Modificar la señal de ser necesario
				px0=~posicion.at(i).at(0); // Posicion pasada
				py0=~posicion.at(i).at(1);
				mag = sqrt(((px0-px)**2)+((py0-py)**2))+0.01;
				// "Velocidad mag".postln;
				// mag.postln;
				if(mag>0,{
					if(mag>0.5,{
						mag=10;
						~ritmos.put(i,5);
						},{
							~ritmos.put(i,1);
					});
				});
			});
		});
	});
	// Si no existía el usuario, agregar a lista
	if(agregar==true,{
		"Agregar".postln;
		// Si el usuario es nuevo, crear su función
		~usrNum.add(usr);
		~usrTmp.add(tmp);
		~posicion.add([px, py]);
		~alturas.add(1);
		~ritmos.add(1);
		~volumenes.add(1);
		~paneos.add(0);
		idFunc =~usrNum.last%~bindsFuncL.size;
		~usrPdefList.add(
			~bindsFuncL.at(idFunc).value(id:usr).play)
	});
	// "Usuarios actualizados".postln;
	// ~usrNum.size.postln;
	// ~usrNum.postln;
};

~cambiarVolumen = {arg usr, vol;
	var idFunc, fecha, tmp;
	fecha = Date.getDate;
	tmp =fecha.rawSeconds;  // SC 3.7
	for(0,~usrNum.size-1,{ arg i;
		// Buscar el usuario en la lista,
		if((usr==~usrNum.at(i)) ,{
			~usrTmp.put(i,tmp);
			~volumenes.put(i,vol);
		});
	});
};

~cambiarRitmos = {arg usr, vol;
	var idFunc, fecha, tmp;
	fecha = Date.getDate;
	tmp =fecha.rawSeconds;  // SC 3.7
	for(0,~usrNum.size-1,{ arg i;
		// Buscar el usuario en la lista,
		if((usr==~usrNum.at(i)) ,{
			~usrTmp.put(i,tmp);
			~ritmos.put(i,vol);
		});
	});
};

~cambiarPaneo = {arg usr, pan;
	var idFunc, fecha, tmp;
	fecha = Date.getDate;
	tmp =fecha.rawSeconds;  // SC 3.7
	for(0,~usrNum.size-1,{ arg i;
		// Buscar el usuario en la lista,
		if((usr==~usrNum.at(i)) ,{
			idFunc =~usrNum.at(i)%~bindsFuncL.size;
			~usrTmp.put(i,tmp);
			~paneos.put(i,(2*pan)-1);
		});
	});
};

/////////////////////////////////////////////////////////
/// Control de usuarios FIN
/////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////
/// Limpia de usuarios inactivos INICIO
/////////////////////////////////////////////////////////
~limpiar = {
	var comparar=0, tmp=0, fecha,ind;
	// Compara si los usuarios no se han comunicado
	// si no, los borra, si si, los deja.
	ind = Array.new(500);
	fecha = Date.getDate;
	"Limpieza".postln;
	tmp =fecha.rawSeconds.postln;  // SC 3.7
	if(~usrTmp.size>0,{
		for(0,~usrTmp.size-1,{ arg i;
			"Limpieza.for".postln;
			comparar = tmp-~usrTmp.at(i);
			"Comparar".postln;
			comparar.postln;
			if(comparar>15 ,{
				"Limpieza.cmparar".postln;
				// guardar el indice por borrar
			//	"Borrar por indicie y diferencia".postln;
			//	i.postln;
			//	comparar.postln;
				ind.add(i);
			});
		});
		// Borrr indices
		if(ind.size>0,{
			for(0,ind.size-1,{ arg i;
				~usrTmp.removeAt(ind.at(i)-i);
				~usrNum.removeAt(ind.at(i)-i);
				~usrPdefList.at(ind.at(i)-i).remove;
				~usrPdefList.removeAt(ind.at(i)-i);
			});
		});
	});
	~usrNum.size.postln;
};

// Ciclo que revisa y limpia
~mir = Routine( {
	loop {
		~limpiar.value;
		//~crearGUI.value;
		1.wait;
	};
});
~mir.play;
////////////////////////////////////////////////////////
/// Limpia de usuarios inactivos FIN,
/////////////////////////////////////////////////////////
)
g = PdefAllGui(20);
[a,b].collect(_.free)
~mir.stop
currentEnvironment.clear;
g.close
s.plotTree
s.meter

[0.6,1].asSpec.map(0)
[0.6,1].asSpec.unmap(0.7)
{SinOsc.ar}.play

s=Server.local;
s.freeAll;
for(0,~usrNum.size-1,{ arg i;
	~usrPdefList.at(i).stop;
});

