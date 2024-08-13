packetTest = {}

local isPressedRActive = false
local hasSentPacket = false  -- Flag para garantir que o pacote é enviado apenas uma vez

-- Tabela para armazenar valores dos packets
packetTest.values = {
    Dword = nil
}

function packetTest.pressedR()
    if not isPressedRActive or hasSentPacket then
        return
    end

    EnableAlphaTest()

    --RenderText3(590 + (ReturnWideScreenX() * 2), 30, "Teste", 50, 3)

    local PacketName = string.format("CT-%s-%d", UserGetName(), UserGetIndex())

    local Packet = 0x40
    local Dword = UserGetIndex()
    local Word = 14532
    local Byte = 201
    local Char = UserGetName()

    CreatePacket(PacketName, Packet)
    SetDwordPacket(PacketName, Dword)
    SetWordPacket(PacketName, Word)
    SetBytePacket(PacketName, Byte)
    SetCharPacket(PacketName, Char)
    SetDwordPacket(PacketName, 5035000)
    SendPacket(PacketName)
    ClearPacket(PacketName)

    DisableAlphaBlend()

    packetTest.texTs()

    -- Definir a flag para indicar que o pacote foi enviado
    hasSentPacket = true

end

function packetTest.Protocol(packet, packetName)

    local packetIdentity = string.format("GS-%s-%d", UserGetName(), UserGetIndex())
    if packetIdentity == PacketName then
        packetTest.CheckPacket(PacketName)
        ClearPacket(PacketName)
        return
    end
  
end

function packetTest.CheckPacket(PacketName)
    local Dword = GetDwordPacket(PacketName, -1)

    packetTest.values.Dword = Dword
end

function packetTest.texTs()
    local dword = packetTest.values.Dword

    RenderText3(590 + (ReturnWideScreenX() * 2), 30, dword, 50, 3)

end

function packetTest.testeKey(key)
    if key == Keys.R then
        if not isPressedRActive then
            -- Se a tecla estava anteriormente desativada, ative-a e envie o pacote
            isPressedRActive = true
            hasSentPacket = false  -- Resetar a flag para permitir o envio do pacote
            InterfaceController.MainProc(packetTest.pressedR)
            --InterfaceController.ClientProtocol(raidTest.Protocol)
        else
            -- Se a tecla está ativa e foi pressionada novamente, desative a flag
            isPressedRActive = false
            hasSentPacket = false  -- Resetar a flag para permitir o envio do pacote na próxima ativação
            -- InterfaceController.MainProc(RemoverFunction) -- Desvincular a função se necessário
        end
    end
end

InterfaceController.MainProcWorldKey(packetTest.testeKey)
InterfaceController.ClientProtocol(packetTest.Protocol)
--InterfaceController.ClientProtocol(raidTest.CheckCreateRaid)

return packetTest