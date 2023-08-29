function Avvio()
    DO(1,1)
    Sleep(500)
    DO(1,0)
    Sleep(500)
    DO(2,1)
    sleep(500)
    while not DI(3) == ON do
        Sleep(250)
    end
    DO(2,0)
end