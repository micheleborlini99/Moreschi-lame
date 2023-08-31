while not Verifica == 2 do

    Sleep(500)

    if DI(4) == ON then
        print("-- MACCHINA IN ERRORE -- INTERVENTO OPERATORE RICHIESTO")
        DOExecute(11,0) -- semaforo verde OFF
        DOExecute(12,1) -- semaforo blu ON
        Sleep(500)
        Pause()
        DOExecute(12,0)  -- semaforo blu OFF
        DOExecute(11,1)  -- semaforo verde ON
    end

    -------- VERIFICHE SEMPRE ATTIVE --------------
    if Verifica == 1 then

        if DI(12) == OFF  then
            print("PALLET 1 NON RILEVATO --  RIPOSIZIONARE")
            DOExecute(11,0) -- semaforo verde OFF
            Sleep(500)
            Pause()
            DOExecute(11,1) -- semaforo verde ON
        end

        if DI(13) == OFF then
            print("PALLET 2 NON RILEVATO --  RIPOSIZIONARE")
            DOExecute(11,0) -- semaforo verde OFF
            Sleep(500)
            Pause()
            DOExecute(11,1) -- semaforo verde ON
        end

    end
    ---------------------------------------------------


    ---------- CONTROLLO PEZZO NEL CENTRATORE ------------

    if Centratore == 1 then
        Sleep(500)
        if DI(11) == OFF then  -- VERIFICA PEZZO PRESENTE NEL CENTRATORE
            DOExecute(11,0)
            DOExecute(12,1)
            print("-- PEZZO NON PRESENTE O COLLOCATO IN MODO ERRATO NEL CENTRATORE --")
            print("-- RICHIESTO INTERVENTO OPERATORE --")
            print("-- RICOLLOCARE IL PEZZO NEL CENTRATORE E RIAVVIARE --")
            Pause()
            DOExecute(12,0)
            DOExecute(11,1)
        end
    end
    -----------------------------------------------------

    ---------- CONTROLLO PRESA TOOL ------------

    if Tool == 1 then
        Tool = 0
        Ricentraggio = 1
        Sleep(500)
        if ToolDI(1) == OFF then  -- VERIFICA TOOL ATTIVO 
            DOExecute(11,0)
            print("-- MANCATA PRESA PEZZO , RIPOSIZIONARE IL PEZZO NEL CENTRATORE -- ")
            Pause()
            DOExecute(11,1)
        end
    end
end