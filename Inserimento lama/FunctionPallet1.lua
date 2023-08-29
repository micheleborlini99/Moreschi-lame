function Pallet1()

while PezziLavorati < DimensionePallet do

MoveJ(P)  -- posizione intermedia pallet1
Move(RP(points_pallet1[Carico],{0,0,40})) -- sopra pezzo
Move(points_pallet1[Carico])  -- presa pezzo
ToolDO(1,1) -- tool attivo
Sleep(1000)

while not ToolDI(1) == ON do
    Sleep(250)
end

if ToolDI(1) == ON then

Move(RP(points_pallet1[Carico],{0,0,40}))
Go(RP((P),{0,0,30})) -- sopra ricentraggio
DO(13,0) -- centratore chiuso

    while not DI(14) == ON do -- DI(14) = centratore chiuso
        Sleep(1500)
        DO(13,1)  -- apro centratore 
        DO(13,0)  -- chiudo centratore
    end

Move(P) -- posizione di ricentraggio
ToolDO(1,0) -- tool spento  
Sleep(1000)
Move(RP((P),{0,0,30})) -- sopra ricentraggio
:: Label2 ::

    while not DI(11) == ON do -- D1(11) = presenza centratore, controllo pezzo 
        Sleep(2000)
        Sync()
        print("-- PEZZO NON PRESENTE O COLLOCATO IN MODO ERRATO NEL CENTRATORE --")
        DO(11,0) -- semaforo verde spento
        DO(12,1) -- semaforo blu scceso
        Pause()
        DO(12,0) -- semaforo blu spento 
        DO(11,1) -- semaforo verde acceso 
        goto Label2
    end

DO(13,1) -- apro centratore
DO(13,0) -- chiudo centratore
Sync()

Move(P) -- posizione attesa fuori macchina

----------ATTESA MACCHINA IN LAVORAZIONE--------

ResetElapsedTime()
Time = ElapsedTime / 1000
    while not DI(3) == OFF and DI(6) == ON do
        Sleep(5000)
        if (Time % 60) == 0 then
            Sync()
            Min = (Time / 60)
            print("-- IL PEZZO E' IN LAVORAZIONE DA: ", Min , " MINUTI --")
        end
    end

-------------------------------------------------

DO(4,0) -- chiudi porta OFF
DO(3,1) -- apri porta ON
    while not DI(2) == ON do
        Sleep(250)
    end

Move(P) -- posizione intermedia centro macchina
Move(P) -- altre posizioni verso posizionatura pezzo
Move(P) -- ////

Move(RP((P),{0,0,30}))  -- Distanza da mandrino

DO(5,0) -- comando elettromagnatico OFF
DO(6,1) --asse lineare in posizione di rilascio o presa 
Move(P) -- contatto con asse lineare e mandrino, punto di rilascio pezzo
ToolDO(1,1) -- attivo Tool

    while not ToolDI(1) == ON do
        Sleep(250)
    end

DO(6,0)  -- asse lineare in posizione di lavoro
Move(RP((P),{0,0,30}))  -- Distanza da mandrino
Move(P) -- posizione intermedia centro macchina
Move(P) -- altre posizioni verso uscita macchina

Move(P) -- posizione attesa fuori macchina

MoveJ(P)  -- posizione intermedia pallet1
Move(RP(points_pallet1[Scarico],{0,0,40})) -- sopra pezzo 
Move(points_pallet1[Scarico])  -- rilascio pezzo lavorato
ToolDO(1,0) -- tool sppento
Sleep(1000)
 while not ToolDI(1) == OFF do
        Sleep(250)
    end

Scarico = Scarico + 1

MoveJ(P)  -- posizione fuori ingombro

Sync()
Go(RP((P3),{0,0,30})) -- sopra ricentraggio
Move(P) -- posizione di ricentraggio
ToolDO(1,1) -- tool attivo, riprendo il pezzo dal centratore
Sleep(1000)

while not ToolDI(1) == ON do
    Sleep(250)
end

Move(RP((P3),{0,0,30})) -- sopra ricentraggio
Move(P) -- posizione attesa fuori macchina

while not DI(3) == OFF and DI(5) == OFF and DI(7) == OFF and DI(2) == ON and DI(1) == OFF do
    Sleep(250)
end

Sync()
print("-- MACCHINA LIBERA E PRONTA PER L'INSERIMENTO DEL PEZZO --")


Move(P) -- posizione intermedia centro macchina
Move(P) -- altre posizioni verso posizionatura pezzo
Move(P) -- ////

Move(RP((P),{0,0,30}))  -- Distanza da mandrino

DO(6,1) -- asse lineare in posizione di presa
DO(5,0) -- comando elettromagnetico spento

while not DI(7) == ON do
    Sleep(250)
end

Sync()
Move(P) -- contatto con asse lineare e mandrino, punto di rilascio pezzo
ToolDO(1,0)  -- spengo tool
Sleep(500)

while not ToolDI(1) == OFF do
    Sleep(250)
end

DO(6,0) -- asse lineare in posizione di lavoro
DO(5,1)  -- attivo comando elettromagnetico
Sleep(500)

while not DI(5) == ON do  -- verifica presenza pezzo in macchina
    Sleep(250)
end

Sync()
print("-- PEZZO IN POSIZIONE --")
Move(RP((P),{0,0,30}))  -- Distanza da mandrino
Move(P) -- posizione intermedia centro macchina
Move(P) -- altre posizioni verso uscita macchina

Move(P) -- posizione attesa fuori macchina

DO(3,0) -- apri porta OFF
DO(4,1) -- chiudi porta ON

    while not DI(1) == ON do -- verifica chiusura porta
        Sleep(250)
    end

    if DI(5) == ON and DI(1) == ON and DI(7) == ON then
        Sleep(500)
        Sync()
        print("-- VERICHE OK, MACCHINA PRONTA PER LA LAVORAZIONE --")
        print("-- AVVIO LAVORAZIONE --")
        Avvio()
        Carico = Carico + 1
    end
PezziLavorati = PezziLavorati + 1
    else
        Carico = Carico + 1
        Sync()
        print("MANCATA PRESA PEZZO -- MI SPOSTO AL PROSSIMO")
    end
end
end