p = ProxySpace.new;

~z.play
~z.release

(
~z={Array.fill(2,{Pan2.ar(
	Limiter.ar(
		CombN.ar(
			SinOsc.ar(PinkNoise.kr(0.9)
				+LFTri.kr(710),SinOsc.kr([122,233],1.5pi,0.5),0.5) // SinOsc
			*LFNoise1.ar(600),0.02,0.0061,1)// fin CombN
		,0.9)) // fin limiter
	})// fin Array
	*EnvGen.kr(Env.perc(5,20,curve:0),doneAction:2)
};
)

l=[20,25,57]
a=Array.fill(3,{arg i; l[i]})