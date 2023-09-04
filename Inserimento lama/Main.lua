local startTime = os.time()

---Set output---

DO(1,0)  -- segnale reset OFF
DO(2,0)  -- segnale start OFF
ToolDO(1,0) -- tool spento
DO(4,0)  -- porta chiusa OFF
DO(3,1)  -- porta aperta ON
DO(12,0) -- semaforo blu OFF
DO(11,1) -- semaforo verde ON
DO(13,0) -- centratore chiuso
DO(5,0)  -- comando elettromagnetico OFF
DO(6,0)  -- asse in posizione di attesa

--- Variabili ---

Carico = 1
Scarico = 1
PezziLavorati = 0
Verifica = 0
Time = 0
Min = 0
DimensionePallet = 25
TOTPezzi = 0
Centratore = 0
Tool = 0
Try = 0
Ricentraggio = 0
Offset = {0,0,35}

--- inizializzazione pallet 1 & 2 ---

local points_pallet1 = {}
PalletCreate({1,2,3,4},{5,5},points_pallet1)

local points_pallet2 = {}
PalletCreate({1,2,3,4},{5,5},points_pallet2)

--------------------------------------------

--- Presa pezzo 1 ---

Sync()
MoveJ(P)  -- posizione fuori ingombro

Verifica = 1

MoveJ(P)  -- posizione intermedia pallet1
Move(RP(points_pallet1[Carico], Offset)) -- sopra pezzo
Move(points_pallet1[Carico])  -- presa pezzo
ToolDO(1,1) -- tool attivo
Sleep(1000)



while not ToolDI(1) == ON do --- controllo presa pezzo, se preso in modo errato riprovare, se non c'è va oltre prova 2 volte 
    Sleep(500)
    Try = Try + 1
    ToolDO(1,0)
    Move(RP(points_pallet1[Carico], Offset))
    Move(points_pallet1[Carico])  -- presa pezzo
    ToolDO(1,1) -- tool attivo
    Sleep(1000)
    if Try == 2 then
        Try = 0
        break
    end
end

if ToolDI(1) == ON then
    Move(RP(points_pallet1[Carico], Offset))
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

    :: Label3 ::

    Move(RP((P), Offset)) -- sopra ricentraggio

    Centratore = 1
    Sleep(1000)
    
    DO(13,1) -- apro centratore
    Sleep(250)
    DO(13,0) -- chiudo centratore

    Centratore = 0

    Sync()
    Move(P) -- posizione di ricentraggio
    ToolDO(1,1) -- tool attivo, riprendo il pezzo dal centratore
    Sleep(1000)
    
    while not ToolDI(1) == ON do --- controllo presa pezzo, se preso in modo errato riprovare, se non c'è si ferma. 
        Sleep(500)
        Try = Try + 1
        ToolDO(1,0)
        Go(RP((P3), Offset)) -- sopra ricentraggio
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
    Go(RP((P3), Offset)) -- sopra ricentraggio
    Move(P) -- posizione attesa fuori macchina
    
    while not DI(3) == OFF and DI(5) == OFF and DI(7) == OFF do
        Sleep(250)
    end
    
    Sync()
    print("-- MACCHINA PRONTA PER LA LAVORAZIONE --")
    
    Sleep(500)
    DO(4,0) -- chiudo porta OFF
    DO(3,1) -- apro porta ON
    
    while not DI(2) == ON do
        Sleep(250)
    end
    
    Move(P) -- posizione intermedia centro macchina
    Move(P) -- altre posizioni verso posizionatura pezzo
    Move(P) -- ////
    
    Move(RP((P), Offset))  -- Distanza da mandrino
    
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
    
  

    Move(RP((P), Offset))  -- Distanza da mandrino
    Move(P) -- posizione intermedia centro macchina
    Move(P) -- altre posizioni verso uscita macchina
    
    Move(P) -- posizione attesa fuori macchina
    
        Sleep(250)
        if DI(5) == OFF then -- VERIFICA PEZZO PRESENTE IN MACCHINA
            Sync()
            print ("-- PEZZO NON PRESENTE --")
            goto Label3
        end
   
    Sync()
    print("-- PEZZO IN POSIZIONE --")
    Sleep(500)
    DO(3,0) -- apri porta OFF
    DO(4,1) -- chiudi porta ON
    
    while not DI(1) == ON do -- verifica chiusura porta
        Sleep(250)
    end
    
    if DI(5) == ON and DI(1) == ON and DI(7) == on then
        Sleep(500)
        Sync()
        print("-- VERICHE OK, MACCHINA PRONTA PER LA LAVORAZIONE --")
        print("-- AVVIO LAVORAZIONE --")
        Avvio()
        Carico = Carico + 1
        PezziLavorati = PezziLavorati + 1
    end
    
    Sync()
    MoveJ(P)  -- posizione fuori ingombro

else
    Carico = Carico + 1
    ToolDO(1,0)
    Sleep(500)
    Sync()
    print("MANCATA PRESA PEZZO -- MI SPOSTO AL PROSSIMO")
end


----- INIZIO PALLET 1 DA SECONDO PEZZO ----

Pallet1()

--- Variabili ripristinate ---

Carico = 1
PezziLavorati = 0

---------------------

Pallet2()

:: Label2 ::

Sync()
MoveJ(P)  -- posizione fuori ingombro
Verifica = 2
Sync()
print("-- PEZZI LAVORATI: ", TOTPezzi, "/", DimensionePallet," --")
local endTime = os.time()
print("-- DURATA: ", math.floor(os.difftime(endTime, startTime) / 60), " MINUTI --")
print("-- CICLO COMPLETATO --")