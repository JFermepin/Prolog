%apareceEn( Personaje, Episodio, Lado de la luz).
apareceEn( luke, elImperioContrataca, luminoso).
apareceEn( luke, unaNuevaEsperanza, luminoso).
apareceEn( vader, unaNuevaEsperanza, oscuro).
apareceEn( vader, laVenganzaDeLosSith, luminoso).
apareceEn( vader, laAmenazaFantasma, luminoso).
apareceEn( c3po, laAmenazaFantasma, luminoso).
apareceEn( c3po, unaNuevaEsperanza, luminoso).
apareceEn( c3po, elImperioContrataca, luminoso).
apareceEn( chewbacca, elImperioContrataca, luminoso).
apareceEn( yoda, elAtaqueDeLosClones, luminoso).
apareceEn( yoda, laAmenazaFantasma, luminoso).

%Agregados
apareceEn(cazarrecompensas,elImperioContrataca).
apareceEn(vader,laVenganzaDeLosSith).
apareceEn(vader,laAmenazaFantasma).

%Maestro(Personaje)
maestro(luke).
maestro(leia).
maestro(vader).
maestro(yoda).
maestro(rey).
maestro(duku).

%caracterizacion(Personaje,Aspecto).
%aspectos:
% ser(Especie,Tamaño)
% humano
% robot(Forma)
caracterizacion(chewbacca,ser(wookiee,10)).
caracterizacion(luke,humano).
caracterizacion(vader,humano).
caracterizacion(yoda,ser(desconocido,5)).
caracterizacion(jabba,ser(hutt,20)).
caracterizacion(c3po,robot(humanoide)).
caracterizacion(bb8,robot(esfera)).
caracterizacion(r2d2,robot(secarropas)).

%Agregados
caracterizacion(cazarrecompensas,ser(clon,15)).

%elementosPresentes(Episodio, Dispositivos)
elementosPresentes(laAmenazaFantasma, [sableLaser]).
elementosPresentes(elAtaqueDeLosClones, [sableLaser, clon]).
elementosPresentes(laVenganzaDeLosSith, [sableLaser, mascara, estrellaMuerte]).
elementosPresentes(unaNuevaEsperanza, [estrellaMuerte, sableLaser, halconMilenario]).
elementosPresentes(elImperioContrataca, [mapaEstelar, estrellaMuerte] ).

%precede(EpisodioAnterior,EpisodioSiguiente)
precedeA(laAmenazaFantasma,elAtaqueDeLosClones).
precedeA(elAtaqueDeLosClones,laVenganzaDeLosSith).
precedeA(laVenganzaDeLosSith,unaNuevaEsperanza).
precedeA(unaNuevaEsperanza,elImperioContrataca).

%-------------------------------

/*
sonIgualesListas([X],Lista2):-
    member(X,Lista2).

sonIgualesListas([X|Lista1],Lista2):-
    member(X,Lista2),
    sonIgualesListas(Lista1,Lista2).
*/

exotico(Extra):-
    caracterizacion(Extra,robot(_)),
    not(caracterizacion(Extra,robot(esfera))).

exotico(Extra):-
    caracterizacion(Extra,ser(_,N)),
    N > 15.

sonDistintos(Heroe,Villano,Extra):-
    heroeValido(Heroe),
    villanoValido(Villano),
    extraValido(Extra),
    Heroe \= Villano,
    Villano \= Extra.

heroeValido(Heroe):-
    apareceEn(Heroe,_,luminoso),
    not(apareceEn(Heroe,_,oscuro)),
    maestro(Heroe).

villanoValido(Villano):-
    apareceEn(Villano,_,luminoso),
    apareceEn(Villano,_,oscuro),
    findall(EpisodioVillano, apareceEn(Villano,EpisodioVillano,_), EpisodiosVillano),
    length(EpisodiosVillano, N),
    N >= 2.

/*
extraValido(Extra,Heroe,Villano):-
    exotico(Extra),
    findall(EpisodioExtra, apareceEn(Extra,EpisodioExtra,_), EpisodiosExtra),
    findall(EpisodioVillano, apareceEn(Villano,EpisodioVillano,_), EpisodiosVillano),
    findall(EpisodioHeroe, apareceEn(Heroe,EpisodioHeroe,_), EpisodiosHeroe),
    append(EpisodiosVillano,EpisodiosHeroe,EpisodiosHeroeVillano),
    list_to_set(EpisodiosHeroeVillano,EpisodiosHeroeVillanoSinRepetidos),
    intersection(EpisodiosHeroeVillanoSinRepetidos,EpisodiosExtra,Interseccion),
    sonIgualesListas(EpisodiosHeroeVillanoSinRepetidos,Interseccion).
*/

extraValido(Extra):-
    exotico(Extra),
    heroeValido(Heroe),
    forall(apareceEn(Heroe,Episodio,_),apareceEn(Extra,Episodio,_)).

extraValido(Extra):-
    exotico(Extra),
    villanoValido(Villano),
    forall(apareceEn(Villano,Episodio,_),apareceEn(Extra,Episodio,_)).

dispositivoValido(Dispositivo):- %Devuelve si es valido o no un dispositivo, no es del todo inversible
    findall(EpisodioDispositivo, (elementosPresentes(EpisodioDispositivo,Lista),member(Dispositivo,Lista)), EpisodiosDispositivo),
    length(EpisodiosDispositivo,N),
    N >= 3.

%-------------------------------

nuevoEpisodio(Heroe, Villano, Extra, Dispositivo):-
    sonDistintos(Heroe,Villano,Extra),
    heroeValido(Heroe),
    villanoValido(Villano),
    extraValido(Extra),
    dispositivoValido(Dispositivo).

/*

1)

54 ?- nuevoEpisodio(luke,vader,c3po,estrellaMuerte).
true 

2)

53 ?- nuevoEpisodio(H,V,E,D).
H = luke,
V = vader,
E = c3po.

H = yoda,
V = vader,
E = c3po

Al no ser del todo inversible el predicado dispositivoValido(Dispositivo), no indica los dispositivos, pero si todas las combinaciones posibles.

*/
    