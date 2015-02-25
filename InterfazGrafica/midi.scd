(
m = SimpleMIDIFile.read("C:/Users/holomorfo/Desktop/cs1-1pre.mid");

// Obtener arreglo de todas las notas
a=m.noteSustainEvents;
~notas=Array.new(a.size);
for(0,a.size-1,{arg i;
    ~notas.add(a.at(i).at(4))
});

// Separar en paquetes de 16 notas
// paquetes es un arreglo de arreglos de 16 notas
~paquetes=Array.new(40);
~temp=Array.new(16);
for(1,~notas.size,{arg i;
    ~temp.add(~notas.at(i-1));
    if((i%16==0),{
        ~paquetes.add(~temp);
        ~temp=Array.new(16);
    });
});
~paquetes.postln;

// Revolver los arreglos
k=~paquetes.scramble;
// Hacerlo una lista largota de notas
k.flatten;
// Tocar
Pbind (
    //\fr, Pseq([a]),
    //\midinote,Pseq(~notas),
    \note,Pseq(k.flatten-60),
    \dur, 0.25/1.5,
    \legato,1
).play
)