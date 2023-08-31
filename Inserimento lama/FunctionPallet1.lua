function Pallet1()

while PezziLavorati < DimensionePallet do

MoveJ(P)  -- posizione intermedia pallet1
Move(RP(points_pallet1[Carico],{0,0,40})) -- sopra pezzo
Move(points_pallet1[Carico])  -- presa pezzo
ToolDO(1,1) -- tool attivo
Sleep(1500)

while not ToolDI(1) == ON do --- controllo presa pezzo, se preso in modo errato riprovare, se non c'è va oltre prova 2 volte 
    Sleep(500)
    Try = Try + 1
    ToolDO(1,0)
    Move(RP(points_pallet1[Carico],{0,0,40}))
    Move(points_pallet1[Carico])  -- presa pezzo
    ToolDO(1,1) -- tool attivo
    Sleep(1000)
    if Try == 2 then
        Try = 0
        break
    end
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

Sleep(1000)

Centratore = 1

DO(13,1) -- apro centratore
DO(13,0) -- chiudo centratore
Sync()
Move(P) -- posizione attesa fuori macchina

----------ATTESA MACCHINA IN LAVORAZIONE--------

ResetElapsedTime()

    while not DI(3) == OFF and DI(6) == ON do
        Sleep(5000)
        Time = math.floor(ElapsedTime / 1000)
        if (Time % 60) == 0 then
            Sync()
            Min = math.floor(Time / 60)
            print("-- IL PEZZO E' IN LAVORAZIONE DA: ", Min , " MINUTI --")
        end
    end

-------------------------------------------------
TOTPezzi = TOTPezzi + 1
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
ToolDO(1,0) -- tool spento
Sleep(1000)

 while not ToolDI(1) == OFF do
        Sleep(250)
    end

Scarico = Scarico + 1

MoveJ(P)  -- posizione fuori ingombro

Sync()

:: Label4 ::
Sleep(500)

Ricentraggio()

Go(RP((P3),{0,0,30})) -- sopra ricentraggio

Centratore = 0

Move(P) -- posizione di ricentraggio
ToolDO(1,1) -- tool attivo, riprendo il pezzo dal centratore
Sleep(1000)

while not ToolDI(1) == ON do --- controllo presa pezzo, se preso in modo errato riprovare, se non c'è si ferma. 
    Sleep(500)
    Try = Try + 1
    ToolDO(1,0)
    Go(RP((P3),{0,0,30})) -- sopra ricentraggio
    Move(P) -- posizione di ricentraggio
    ToolDO(1,1) -- tool attivo
    Sleep(1000)
    if Try == 2 then
        Try = 0
        Sync()
        print("-- RIPOSIZIONARE IL PEZZO NEL CENTRATORE -- ")
        Pause()
    end
end
Tool = 1
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

Tool = 0

Sleep(500)
ToolDO(1,0)  -- spengo tool
Sleep(500)

while not ToolDI(1) == OFF do
    Sleep(250)
end

DO(6,0) -- asse lineare in posizione di lavoro
DO(5,1)  -- attivo comando elettromagnetico
Sleep(500)


Move(RP((P),{0,0,30}))  -- Distanza da mandrino
Move(P) -- posizione intermedia centro macchina
Move(P) -- altre posizioni verso uscita macchina

Move(P) -- posizione attesa fuori macchina

    Sleep(250)
    if DI(5) == OFF then  -- VERIFICA PEZZO PRESENTE IN MACCHINA
        Sync()
        print ("-- PEZZO NON PRESENTE --")
        goto Label4
    end

DO(3,0) -- apri porta OFF
DO(4,1) -- chiudi porta ON


    while not DI(5) == ON and DI(1) == ON and DI(7) == ON do
        Sleep(500)
    end

        Sleep(500)
        Sync()
        print("-- VERICHE OK, MACCHINA PRONTA PER LA LAVORAZIONE --")
        print("-- AVVIO LAVORAZIONE --")
        Avvio()
        Carico = Carico + 1
        PezziLavorati = PezziLavorati + 1
    else
        Carico = Carico + 1
        Sync()
        print("MANCATA PRESA PEZZO -- MI SPOSTO AL PROSSIMO")
    end
end
end