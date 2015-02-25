Pbind(\midinote,Prand([1,2,3,4,5,6]+60,inf)).play

Server.default.makeGui;


(
Dialog.openPanel({ arg path;
    path.postln;
},{
    "cancelled".postln;
});
)