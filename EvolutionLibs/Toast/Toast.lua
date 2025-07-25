-- Toast/Toast.lua - Sistema de notificaciones tipo toast

local Toast = {}

function Toast.show(text, type, duration, parent)
    -- Fallback simple si no hay implementación real
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = type or "Info",
        Text = text or "",
        Duration = duration or 2
    })
end

Toast.Success = Toast.show
Toast.Error = Toast.show
Toast.Warning = Toast.show
Toast.Info = Toast.show

return Toast
