-- Hotkeys Manager para EvolutionLibs
local UserInputService = game:GetService("UserInputService")

local HotkeyManager = {
    _version = "1.0.0",
    _hotkeys = {},
    _listening = false,
    _currentCallback = nil
}

-- Convertir KeyCode a texto legible
function HotkeyManager.getKeyName(keyCode)
    if typeof(keyCode) == "EnumItem" then
        return keyCode.Name
    end
    return "None"
end

-- Convertir texto a KeyCode
function HotkeyManager.getKeyCode(keyName)
    if keyName == "None" then return nil end
    return Enum.KeyCode[keyName]
end

-- Registrar una nueva hotkey
function HotkeyManager.register(id, defaultKey, callback)
    HotkeyManager._hotkeys[id] = {
        key = HotkeyManager.getKeyCode(defaultKey),
        callback = callback,
        enabled = true
    }
end

-- Cambiar una hotkey
function HotkeyManager.setHotkey(id, newKey)
    if HotkeyManager._hotkeys[id] then
        HotkeyManager._hotkeys[id].key = newKey
        -- Guardar en configuración
        local success, err = pcall(function()
            if not _G.EvoLibsConfig then _G.EvoLibsConfig = {} end
            if not _G.EvoLibsConfig.Hotkeys then _G.EvoLibsConfig.Hotkeys = {} end
            _G.EvoLibsConfig.Hotkeys[id] = HotkeyManager.getKeyName(newKey)
        end)
        if not success then
            warn("[EvolutionLibs] Error al guardar hotkey:", err)
        end
    end
end

-- Obtener la hotkey actual
function HotkeyManager.getHotkey(id)
    if HotkeyManager._hotkeys[id] then
        return HotkeyManager._hotkeys[id].key
    end
    return nil
end

-- Activar/desactivar una hotkey
function HotkeyManager.setEnabled(id, enabled)
    if HotkeyManager._hotkeys[id] then
        HotkeyManager._hotkeys[id].enabled = enabled
    end
end

-- Iniciar escucha de hotkey
function HotkeyManager.startListening(callback)
    if HotkeyManager._listening then return end
    
    HotkeyManager._listening = true
    HotkeyManager._currentCallback = callback
    
    -- Visual feedback
    if callback then
        callback("Presiona una tecla...")
    end
end

-- Detener escucha de hotkey
function HotkeyManager.stopListening()
    HotkeyManager._listening = false
    HotkeyManager._currentCallback = nil
end

-- Cargar configuración guardada
function HotkeyManager.loadConfig()
    local success, err = pcall(function()
        if _G.EvoLibsConfig and _G.EvoLibsConfig.Hotkeys then
            for id, keyName in pairs(_G.EvoLibsConfig.Hotkeys) do
                if HotkeyManager._hotkeys[id] then
                    HotkeyManager._hotkeys[id].key = HotkeyManager.getKeyCode(keyName)
                end
            end
        end
    end)
    if not success then
        warn("[EvolutionLibs] Error al cargar configuración de hotkeys:", err)
    end
end

-- Conectar eventos de input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if HotkeyManager._listening then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            if HotkeyManager._currentCallback then
                HotkeyManager._currentCallback(HotkeyManager.getKeyName(input.KeyCode))
            end
            HotkeyManager.stopListening()
        end
        return
    end
    
    for id, hotkey in pairs(HotkeyManager._hotkeys) do
        if hotkey.enabled and hotkey.key and input.KeyCode == hotkey.key then
            if hotkey.callback then
                hotkey.callback()
            end
        end
    end
end)

return HotkeyManager
