while not Verifica == 2 do
    Sleep(500)

    if DI(12) == OFF  then
        print("PALLET 1 NON RILEVATO --  RIPOSIZIONARE")
        DOExecute(11,0) -- semaforo verde spento
        Sleep(500)
        Pause()
    end

    if DI(13) == OFF then
        print("PALLET 2 NON RILEVATO --  RIPOSIZIONARE")
        DOExecute(11,0) -- semaforo verde spento
        Sleep(500)
        Pause()
    end

    if DI(4) == ON then
        print("-- MACCHINA IN ERRORE -- INTERVENTO OPERATORE RICHIESTO")
        DOExecute(11,0) -- semaforo verde spento
        Sleep(500)
        Pause()
    end

    while Verifica == 1 do

        ---- VERIFICA PORTA APERTA ---
        if DI(2) == ON then
            print("PORTA APERTA MENTRE MACCHINA N LAVORAZIONE -- ERRORE INTERVENIRE")
            DOExecute(11,0) -- semaforo verde spento
            Sleep(500)
            Pause()
        end
    end
end