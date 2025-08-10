-- Function to pair your sender with a receiver
local function pairSender(receiver_id, protocol)
    while true do
        rednet.send(receiver_id, "pair", protocol)
        local received_id, msg, received_protocol = rednet.receive(protocol, 3)

        if received_id == receiver_id and msg == "paired" and received_protocol == protocol then
            return {true, nil}
        end
    end
end

-- Function to pair your receiver with a sender
local function pairReceiver(sender_id, protocol) 
    local received_id, msg, received_protocol = rednet.receive(protocol)

    if received_id == sender_id and msg == "pair" and received_protocol == protocol then
        sleep(1)
        rednet.send(sender_id, "paired", protocol)
        return {true, nil}
    end

    return {false, {received_id, msg, received_protocol}}
end

-- Function to receive a message from a specified sender with a specified protocol
local function getMessage(sender_id, protocol)
    local received_id, msg, received_protocol
    repeat
        received_id, msg, received_protocol = rednet.receive(protocol)
    until received_id == sender_id and received_protocol == protocol
    return msg
end

return {
    pairSender = pairSender,
    pairReceiver = pairReceiver,
    getMessage = getMessage,
}