eclipse("Arrecifes", "Buenos Aires", horario(17,44), altura(2.5), duracion(0,40)).
eclipse("Carmen de Areco", "Buenos Aires", horario(17,44), altura(2.1), duracion(1,30)).
eclipse("Pergamino", "Buenos Aires", horario(17,44), altura(2.9), duracion(0,56)).
eclipse("Chacabuco", "Buenos Aires", horario(17,43), altura(2.6), duracion(2,07)).
eclipse("Ezeiza", "Buenos Aires", horario(17,44), altura(0.9), duracion(1,01)).
eclipse("Rodeo", "San Juan", horario(17,41), altura(11.5), duracion(2,16)).
eclipse("Jachal", "San Juan", horario(17,41), altura(11.1), duracion(1,39)).
eclipse("Bella Vista", "San Juan", horario(17,41), altura(11.5), duracion(2,27)).
eclipse("Merlo", "San Luis", horario(17,42), altura(7.1), duracion(2,19)).
eclipse("Quines", "San Luis", horario(17,42), altura(7.8), duracion(2,13)).
eclipse("Chepes", "La Rioja", horario(17,42), altura(8.9), duracion(2,03)).
eclipse("Rio Cuarto", "Cordoba", horario(17,42), altura(6.3), duracion(1,54)).
eclipse("Venado Tuerto", "Santa Fe", horario(17,43), altura(4.1), duracion(2,11)).

telescopio("Bella Vista").
telescopio("Chepes").
telescopio("Ezeiza").

reposeraPublica("Chacabuco").
reposeraPublica("Arrecifes").
reposeraPublica("Chepes").
reposeraPublica("Venado Tuerto").

observatorioAstronomico("Quines").

lentesParaSol("Quines").
lentesParaSol("Rodeo").
lentesParaSol("Rio Cuarto").
lentesParaSol("Merlo").

alturaMayorA10(Ciudad):-
    eclipse(Ciudad,_,_,altura(Altura),_),
    Altura > 10.

empiezaDespuesDeLas(Ciudad):-
    eclipse(Ciudad,_,horario(_,Minutos),_,_),
    Minutos > 42.

ningunServicio(Ciudad):- %Este predicado es inversible
    ciudad(Ciudad),
    not(telescopio(Ciudad)),
    not(reposeraPublica(Ciudad)),
    not(observatorioAstronomico(Ciudad)),
    not(lentesParaSol(Ciudad)).

provinciasConUnaCiudad(Provincia):-
    eclipse(_, Provincia, _, _, _),
    findall(Ciudad, eclipse(Ciudad, Provincia, _, _, _), Ciudades),
    length(Ciudades, 1).

mayorDuracion(Ciudad):-
    eclipse(Ciudad,_,_,_,Duracion),
    forall(eclipse(_,_,_,_,OtraDuracion),duracionMayor(Duracion,OtraDuracion)).

promedioPais(duracion(Minutos,Segundos)):- %Este predicado es inversible
    findall(DuracionEnSegundos,(eclipse(_,_,_,_,Duracion),duracionEnSegundos(DuracionEnSegundos,Duracion)),Duraciones),
    calcularPromedio(Duraciones,Minutos,Segundos).
    
promedioProvincia(duracion(Minutos,Segundos),Provincia):- %Este predicado es inversible
    provincia(Provincia),
    findall(DuracionEnSegundos,(eclipse(_,Provincia,_,_,Duracion),duracionEnSegundos(DuracionEnSegundos,Duracion)),Duraciones),
    calcularPromedio(Duraciones,Minutos,Segundos).

promedioCiudadConTelescopio(duracion(Minutos,Segundos),Ciudad):- %Este predicado es inversible
    ciudad(Ciudad),
    telescopio(Ciudad),
    findall(DuracionEnSegundos,(eclipse(Ciudad,_,_,_,Duracion),duracionEnSegundos(DuracionEnSegundos,Duracion)),Duraciones),
    calcularPromedio(Duraciones,Minutos,Segundos).


%------------------Auxiliar------------------

duracionMayor(duracion(Minutos,_),duracion(OtrosMinutos,_)):-
    Minutos > OtrosMinutos.

duracionMayor(duracion(Minutos,Segundos),duracion(Minutos,OtrosSegundos)):-
    Segundos >= OtrosSegundos.

duracionEnSegundos(DuracionEnSegundos,duracion(Minutos,Segundos)):-
    DuracionEnSegundos is Minutos * 60 + Segundos.
    
calcularPromedio(Duraciones,Minutos,Segundos):-
    sumlist(Duraciones,Sum),
    length(Duraciones,Tamanio),
    Minutos is (Sum // Tamanio) // 60,
    Segundos is (Sum // Tamanio) mod 60.

provincia(P):-
    eclipse(_,P,_,_,_).
    
ciudad(C):-
    eclipse(C,_,_,_,_).