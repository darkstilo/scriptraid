packetTest = {}

function packetTest.Protocol(aIndex, Packet, PacketName)
    --LogAdd(Packet)
	if Packet == 0x40
	then 

        local player = User.new(aIndex)
        local getName = player:getName()
        local getIndex = player:getIndex()

        local nome = PacketName
        local Dword = GetDwordPacket(PacketName, -1)
        local Word = GetWordPacket(PacketName, -1)
        local Byte = GetBytePacket(PacketName, -1)
        local Char = GetCharPacket(PacketName, -1)
        local Dword2 = GetDwordPacket(PacketName, -1)        

        ClearPacket(PacketName)
        LogAdd(string.format("O servidor recebeu pacote do jogador: %s do client. Pacote: Dword1: %d, Word: %d, Byte: %d, Char: %s, Dword2: %d",
            getName, Dword, Word, Byte, Char, Dword2))
        SendMessage(string.format("O servidor recebeu o seu pacotess."), aIndex, 1)
        
        --local PacketSendName = string.format("GS-%s-%d", getName(), getIndex()) 
        local PacketSendName = string.format("GS-%s-%d", getName, getIndex)
        LogAdd(PacketSendName)
        
        CreatePacket(PacketSendName, 0x40)
        SetDwordPacket(PacketSendName, 255)
        SendPacket(PacketSendName)
        
        ClearPacket(PacketSendName)

         
    end
end

function packetTest.Init()	
	GameServerFunctions.GameServerProtocol(packetTest.Protocol)
end

packetTest.Init()

return packetTest