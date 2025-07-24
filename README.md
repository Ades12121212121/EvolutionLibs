# 🎨 EvolutionLibs Designs - Wiki Completa

## 📋 Tabla de Contenidos

- [Introducción](#introducción)
- [Instalación y Configuración](#instalación-y-configuración)
- [Temas Disponibles](#temas-disponibles)
- [API Simplificada](#api-simplificada)
- [Sistema de Efectos](#sistema-de-efectos)
- [Animaciones](#animaciones)
- [Componentes Presets](#componentes-presets)
- [Layouts Inteligentes](#layouts-inteligentes)
- [Utilidades Avanzadas](#utilidades-avanzadas)
- [Configuración Avanzada](#configuración-avanzada)
- [Ejemplos Prácticos](#ejemplos-prácticos)
- [Solución de Problemas](#solución-de-problemas)

---

## 🚀 Introducción

**EvolutionLibs Designs** es un sistema avanzado de diseño para interfaces de usuario en Roblox que combina:

- ✨ **Simplicidad para usuarios**: API intuitiva y fácil de usar
- 🔧 **Complejidad interna**: Sistema robusto con múltiples características
- 🎭 **Temas modernos**: 5 temas predefinidos y generación automática
- 🌟 **Efectos visuales**: Sombras, brillos, partículas y animaciones
- 📱 **Componentes listos**: Botones, sliders, toggles y más
- ⚡ **Alto rendimiento**: Optimizado para experiencias fluidas

---

## 📦 Instalación y Configuración

### Instalación Básica

```lua
-- Cargar el módulo
local Designs = require(path.to.Designs)

-- Configuración inicial (opcional)
local theme = Designs.Simple.Setup("Dark", {
    EnableGlow = true,
    EnableParticles = true,
    AnimationSpeed = 0.3
})
```

### Configuración Personalizada

```lua
-- Configuración avanzada
Designs.Utils.Configure({
    DefaultTheme = "Cyberpunk",
    AnimationSpeed = 0.25,
    EnableParticles = true,
    EnableSounds = false,
    EnableGradients = true,
    EnableGlow = true,
    EnableBlur = false,
    GlobalScale = 1.0,
    BorderRadius = 8,
    ShadowIntensity = 0.3
})
```

---

## 🎨 Temas Disponibles

### 1. **Dark Theme** (Predeterminado)
Tema oscuro moderno con colores suaves y profesionales.

```lua
-- Colores principales
Background = Color3.fromRGB(18, 18, 24)
Surface = Color3.fromRGB(28, 28, 36)
Primary = Color3.fromRGB(88, 166, 255)
Accent = Color3.fromRGB(255, 107, 129)
```

### 2. **Light Theme**
Tema claro y limpio ideal para aplicaciones diurnas.

```lua
-- Uso
local theme = Designs.Simple.ApplyGlobalTheme("Light")
```

### 3. **Cyberpunk Theme**
Tema futurista con colores neón y efectos brillantes.

```lua
-- Características especiales
- Colores neón (cyan, magenta)
- Efectos de brillo intensos
- Bordes angulares
- Partículas de colores vibrantes
```

### 4. **Nature Theme**
Tema inspirado en la naturaleza con tonos verdes y tierra.

```lua
-- Paleta natural
- Verdes naturales
- Acentos dorados
- Bordes redondeados
- Efectos suaves
```

### 5. **Ocean Theme**
Tema acuático con azules profundos y efectos fluidos.

```lua
-- Características marinas
- Azules oceánicos
- Efectos de onda
- Transparencias como agua
- Animaciones fluidas
```

---

## 🎯 API Simplificada

### Configuración Inicial

```lua
-- Setup básico
local theme = Designs.Simple.Setup("NombreDelTema", opciones)

-- Setup con todas las opciones
local theme = Designs.Simple.Setup("Dark", {
    EnableGlow = true,
    EnableParticles = false,
    AnimationSpeed = 0.4,
    GlobalScale = 1.2
})
```

### Crear Componentes

```lua
-- Sintaxis general
local componente = Designs.Simple.Create("TipoComponente", parent, configuracion)
```

#### Ejemplos de Componentes

**Botón Moderno:**
```lua
local button = Designs.Simple.Create("Button", parent, {
    Text = "Presiona aquí",
    Style = "Primary", -- "Primary", "Secondary"
    Theme = "Dark"
})
```

**Card Elegante:**
```lua
local card = Designs.Simple.Create("Card", parent, {
    Gradient = true,
    Theme = "Ocean"
})
```

**Toggle Avanzado:**
```lua
local toggle = Designs.Simple.Create("Toggle", parent, {
    Text = "Activar función",
    Default = false,
    Callback = function(state)
        print("Toggle:", state)
    end
})
```

**Slider Estilizado:**
```lua
local slider = Designs.Simple.Create("Slider", parent, {
    Text = "Volumen",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        print("Nuevo valor:", value)
    end
})
```

**Notificación:**
```lua
Designs.Simple.Create("Notification", nil, {
    Text = "Operación completada",
    Type = "success", -- "success", "error", "warning", "info"
    Duration = 3
})
```

### Temas Personalizados

```lua
-- Generar tema desde color base
local miTema = Designs.Simple.CustomTheme(
    Color3.fromRGB(255, 100, 150), 
    "MiTemaPersonalizado"
)

-- Aplicar tema personalizado
Designs.Simple.ApplyGlobalTheme("MiTemaPersonalizado")
```

---

## ✨ Sistema de Efectos

### Sombras

```lua
-- Crear sombra automática
local shadow = Designs.Effects.CreateShadow(elemento, theme, intensidad)

-- Parámetros:
-- elemento: Frame o elemento UI
-- theme: Tema a usar
-- intensidad: 0.0 - 1.0 (opcional)
```

### Efectos de Brillo (Glow)

```lua
-- Crear efecto de brillo
local glow = Designs.Effects.CreateGlow(elemento, theme, intensidad)

-- Se aplica automáticamente si EnableGlow = true
```

### Gradientes

```lua
-- Aplicar gradiente
local gradient = Designs.Effects.ApplyGradient(elemento, gradientData, direccion)

-- Ejemplo
Designs.Effects.ApplyGradient(button, theme.PrimaryGradient, "Vertical")
```

### Efecto Ripple (Ondas)

```lua
-- Crear efecto de ondas al hacer click
Designs.Effects.CreateRipple(elemento, color, duracion)

-- Ejemplo
Designs.Effects.CreateRipple(button, Color3.fromRGB(255, 255, 255), 0.6)
```

### Sistema de Partículas

```lua
-- Crear partículas animadas
local particles = Designs.Effects.CreateParticles(elemento, theme, cantidad)

-- Parámetros:
-- elemento: Contenedor padre
-- theme: Tema para colores
-- cantidad: Número de partículas (defecto: 20)
```

---

## 🎭 Animaciones

### Animaciones Básicas

**Fade In/Out:**
```lua
-- Aparecer gradualmente
Designs.Animations.FadeIn(elemento, duracion, delay)

-- Desaparecer gradualmente
Designs.Animations.FadeOut(elemento, duracion, callback)
```

**Rebote (Bounce):**
```lua
-- Efecto de rebote
Designs.Animations.Bounce(elemento, intensidad, duracion)

-- Ejemplo: rebote suave al hacer hover
Designs.Animations.Bounce(button, 1.1, 0.2)
```

**Pulso:**
```lua
-- Animación de pulso
Designs.Animations.Pulse(elemento, intensidad, duracion, infinito)

-- Ejemplo: pulso infinito
Designs.Animations.Pulse(indicator, 1.2, 1.0, true)
```

**Deslizamiento:**
```lua
-- Deslizar elemento desde una dirección
Designs.Animations.SlideIn(elemento, direccion, distancia, duracion)

-- Direcciones: "Left", "Right", "Up", "Down"
Designs.Animations.SlideIn(panel, "Left", 300, 0.5)
```

### Efectos de Hover

```lua
-- Agregar efecto al pasar el mouse
Designs.Utils.AddHoverEffect(elemento, theme, estilo)

-- Estilos disponibles:
-- "Subtle" - Cambio sutil de color
-- "Glow" - Efecto de brillo
-- "Lift" - Elevación visual
-- "Pulse" - Pulso al hacer hover
```

---

## 🧩 Componentes Presets

### Botón Moderno

```lua
local button = Designs.Presets.ModernButton(parent, texto, theme, estilo)

-- Características:
-- - Efecto ripple automático
-- - Hover con brillo
-- - Animación de entrada
-- - Esquinas redondeadas
-- - Sombra sutil
```

### Card Elegante

```lua
local card = Designs.Presets.ElegantCard(parent, theme, conGradiente)

-- Características:
-- - Sombra profesional
-- - Efecto hover de elevación
-- - Padding interno automático
-- - Esquinas redondeadas
-- - Soporte para gradientes
```

### Toggle Avanzado

```lua
local toggle = Designs.Presets.AdvancedToggle(parent, texto, valorInicial, callback, theme)

-- Características:
-- - Animación suave del switch
-- - Efecto de rebote
-- - Colores dinámicos
-- - Sombra en el control
-- - Efecto ripple
```

### Slider Estilizado

```lua
local slider = Designs.Presets.StyledSlider(parent, texto, min, max, valorInicial, callback, theme)

-- Características:
-- - Gradiente en la barra de progreso
-- - Handle con sombra y brillo
-- - Animaciones suaves
-- - Valor en tiempo real
-- - Drag & drop fluido
```

---

## 📐 Layouts Inteligentes

### Grid Responsivo

```lua
local grid, gridLayout = Designs.Layouts.ResponsiveGrid(parent, columnas, espaciado, theme)

-- Ejemplo de uso
local grid = Designs.Layouts.ResponsiveGrid(container, 3, 10, theme)

-- Agregar elementos al grid
for i = 1, 9 do
    local card = Designs.Simple.Create("Card", grid, {Theme = "Dark"})
    card.LayoutOrder = i
end
```

### Lista con Scroll Suave

```lua
local scrollList = Designs.Layouts.SmoothScrollList(parent, theme)

-- Características:
-- - Auto-resize del contenido
-- - Scrollbar personalizada
-- - Padding automático
-- - Esquinas redondeadas
```

---

## 🛠️ Utilidades Avanzadas

### Aplicar Tema a Elemento

```lua
-- Aplicar tema completo
Designs.Utils.ApplyTheme(elemento, theme, estilo)

-- Estilos: "Primary", "Secondary", "Surface"
```

### Crear Tema Personalizado

```lua
-- Desde color base
local temaPersonalizado = Designs.Utils.CreateCustomTheme(colorBase, nombre)

-- Ejemplo
local miTema = Designs.Utils.CreateCustomTheme(
    Color3.fromRGB(200, 50, 150), 
    "TemaRosa"
)
```

### Interpolar Temas

```lua
-- Mezclar dos temas
local temaMezclado = Designs.Utils.BlendThemes(tema1, tema2, factor)

-- factor: 0.0 = tema1, 1.0 = tema2, 0.5 = 50% de cada uno
```

### Generar Tema Aleatorio

```lua
-- Crear tema aleatorio
local temaAleatorio = Designs.Utils.GenerateRandomTheme("TemaRandom")
```

### Sistema de Notificaciones

```lua
-- Notificación completa
local notification = Designs.Utils.CreateNotification(texto, tipo, duracion, theme)

-- Tipos: "info", "success", "error", "warning"
-- Ejemplo
Designs.Utils.CreateNotification(
    "¡Configuración guardada correctamente!", 
    "success", 
    4,
    Designs.Themes.Dark
)
```

---

## ⚙️ Configuración Avanzada

### Opciones Globales

```lua
local config = {
    DefaultTheme = "Dark",           -- Tema por defecto
    AnimationSpeed = 0.3,           -- Velocidad de animaciones
    EnableParticles = true,         -- Habilitar partículas
    EnableSounds = false,           -- Habilitar sonidos
    EnableGradients = true,         -- Habilitar gradientes
    EnableGlow = true,              -- Habilitar efectos de brillo
    EnableBlur = false,             -- Habilitar desenfoque
    GlobalScale = 1.0,              -- Escala global
    BorderRadius = 8,               -- Radio de bordes
    ShadowIntensity = 0.3          -- Intensidad de sombras
}

Designs.Utils.Configure(config)
```

### Obtener Configuración Actual

```lua
local configActual = Designs.Utils.GetConfig()
print("Tema actual:", configActual.DefaultTheme)
print("Efectos habilitados:", configActual.EnableGlow)
```

### Configuración por Tema

Cada tema tiene su propia configuración específica:

```lua
-- Acceder a configuración de tema
local theme = Designs.Themes.Dark
print("Radio de bordes:", theme.BorderRadius)
print("Velocidad de animación:", theme.AnimationSpeed)
print("Intensidad de brillo:", theme.GlowIntensity)
```

---

## 💡 Ejemplos Prácticos

### Ejemplo 1: Panel de Configuración

```lua
-- Configurar el sistema
local theme = Designs.Simple.Setup("Dark", {
    EnableGlow = true,
    EnableParticles = false
})

-- Crear contenedor principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui

-- Aplicar tema al contenedor
Designs.Utils.ApplyTheme(mainFrame, theme, "Surface")

-- Crear título
local titleCard = Designs.Simple.Create("Card", mainFrame, {Theme = "Dark"})
titleCard.Size = UDim2.new(1, -20, 0, 60)
titleCard.Position = UDim2.new(0, 10, 0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "⚙️ Configuración"
title.TextColor3 = theme.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = titleCard

-- Crear controles
local volumeSlider = Designs.Simple.Create("Slider", mainFrame, {
    Text = "🔊 Volumen",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        print("Volumen ajustado a:", value .. "%")
    end
})
volumeSlider.Position = UDim2.new(0, 10, 0, 90)

local soundToggle = Designs.Simple.Create("Toggle", mainFrame, {
    Text = "🔉 Habilitar Sonidos",
    Default = true,
    Callback = function(enabled)
        print("Sonidos:", enabled and "Activados" or "Desactivados")
    end
})
soundToggle.Position = UDim2.new(0, 10, 0, 170)

local particlesToggle = Designs.Simple.Create("Toggle", mainFrame, {
    Text = "✨ Efectos de Partículas",
    Default = false,
    Callback = function(enabled)
        Designs.Utils.Configure({EnableParticles = enabled})
    end
})
particlesToggle.Position = UDim2.new(0, 10, 0, 240)

-- Botones de acción
local saveButton = Designs.Simple.Create("Button", mainFrame, {
    Text = "💾 Guardar Configuración",
    Style = "Primary"
})
saveButton.Position = UDim2.new(0, 10, 1, -120)
saveButton.Size = UDim2.new(0.48, -5, 0, 45)

local cancelButton = Designs.Simple.Create("Button", mainFrame, {
    Text = "❌ Cancelar",
    Style = "Secondary"
})
cancelButton.Position = UDim2.new(0.52, 5, 1, -120)
cancelButton.Size = UDim2.new(0.48, -5, 0, 45)

-- Conectar eventos
saveButton.MouseButton1Click:Connect(function()
    Designs.Simple.Create("Notification", nil, {
        Text = "✅ Configuración guardada correctamente",
        Type = "success",
        Duration = 3
    })
end)

cancelButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)
```

### Ejemplo 2: Dashboard con Métricas

```lua
-- Setup tema cyberpunk
local theme = Designs.Simple.Setup("Cyberpunk", {
    EnableGlow = true,
    EnableParticles = true
})

-- Crear dashboard
local dashboard = Instance.new("Frame")
dashboard.Size = UDim2.new(0, 800, 0, 600)
dashboard.Position = UDim2.new(0.5, -400, 0.5, -300)
dashboard.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui

Designs.Utils.ApplyTheme(dashboard, theme, "Surface")

-- Grid para métricas
local grid, gridLayout = Designs.Layouts.ResponsiveGrid(dashboard, 2, 15, theme)
grid.Size = UDim2.new(1, -20, 1, -20)
grid.Position = UDim2.new(0, 10, 0, 10)

-- Crear cards de métricas
local metrics = {
    {title = "👥 Usuarios Activos", value = "1,234", color = theme.Success},
    {title = "💰 Ingresos", value = "$45,678", color = theme.Warning},
    {title = "📊 Rendimiento", value = "98.5%", color = theme.Primary},
    {title = "🚀 Velocidad", value = "2.3s", color = theme.Accent}
}

for i, metric in ipairs(metrics) do
    local card = Designs.Simple.Create("Card", grid, {
        Gradient = true,
        Theme = "Cyberpunk"
    })
    card.LayoutOrder = i
    
    -- Título de la métrica
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = metric.title
    titleLabel.TextColor3 = theme.TextSecondary
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = card
    
    -- Valor de la métrica
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0.6, 0)
    valueLabel.Position = UDim2.new(0, 0, 0.4, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = metric.value
    valueLabel.TextColor3 = metric.color
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 32
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.Parent = card
    
    -- Animación de entrada escalonada
    Designs.Animations.SlideIn(card, "Up", 50, 0.4)
    wait(0.1) -- Delay entre cards
end
```

### Ejemplo 3: Tema Personalizado

```lua
-- Crear tema personalizado desde color favorito
local miColorFavorito = Color3.fromRGB(255, 20, 147) -- Rosa fuerte
local miTema = Designs.Simple.CustomTheme(miColorFavorito, "TemaPersonal")

-- Aplicar tema personalizado
Designs.Simple.ApplyGlobalTheme("TemaPersonal")

-- Crear interfaz con tema personalizado
local ventana = Instance.new("Frame")
ventana.Size = UDim2.new(0, 300, 0, 400)
ventana.Position = UDim2.new(0.5, -150, 0.5, -200)
ventana.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui

Designs.Utils.ApplyTheme(ventana, miTema, "Surface")

-- Componentes con tema personalizado
local button1 = Designs.Simple.Create("Button", ventana, {
    Text = "Mi Botón Personalizado",
    Theme = "TemaPersonal"
})
button1.Position = UDim2.new(0, 20, 0, 50)

local slider1 = Designs.Simple.Create("Slider", ventana, {
    Text = "Control Personalizado",
    Min = 0,
    Max = 100,
    Default = 50,
    Theme = "TemaPersonal"
})
slider1.Position = UDim2.new(0, 20, 0, 120)

-- Mostrar notificación con tema personalizado
Designs.Utils.CreateNotification(
    "¡Tema personalizado aplicado!",
    "success",
    4,
    miTema
)
```

---

## 🔧 Solución de Problemas

### Problemas Comunes

**1. Los efectos no se muestran:**
```lua
-- Verificar configuración
local config = Designs.Utils.GetConfig()
print("Glow habilitado:", config.EnableGlow)
print("Gradientes habilitados:", config.EnableGradients)

-- Habilitar efectos
Designs.Utils.Configure({
    EnableGlow = true,
    EnableGradients = true
})
```

**2. Animaciones muy lentas/rápidas:**
```lua
-- Ajustar velocidad global
Designs.Utils.Configure({
    AnimationSpeed = 0.2 -- Más rápido
})

-- O ajustar por animación individual
Designs.Animations.FadeIn(elemento, 0.1) -- Muy rápido
```

**3. Tema no se aplica correctamente:**
```lua
-- Verificar que el tema existe
if Designs.Themes["MiTema"] then
    print("Tema encontrado")
else
    print("Tema no existe, creando...")
    local nuevoTema = Designs.Utils.CreateCustomTheme(
        Color3.fromRGB(100, 150, 200), 
        "MiTema"
    )
end
```

**4. Elementos no aparecen:**
```lua
-- Verificar ZIndex
elemento.ZIndex = 10

-- Verificar transparencia
elemento.BackgroundTransparency = 0
elemento.TextTransparency = 0

-- Verificar tamaño y posición
print("Tamaño:", elemento.Size)
print("Posición:", elemento.Position)
```

### Optimización de Rendimiento

```lua
-- Para mejor rendimiento, deshabilitar efectos no esenciales
Designs.Utils.Configure({
    EnableParticles = false,  -- Las partículas consumen más recursos
    EnableGlow = false,       -- Los brillos pueden impactar FPS
    AnimationSpeed = 0.1     -- Animaciones más rápidas
})
```

### Debug y Diagnóstico

```lua
-- Información del sistema
local config = Designs.Utils.GetConfig()
for key, value in pairs(config) do
    print(key .. ":", value)
end

-- Listar temas disponibles
for themeName, themeData in pairs(Designs.Themes) do
    print("Tema disponible:", themeName)
end
```

---

## 📚 Referencias Rápidas

### Colores de Temas por Nombre
- `theme.Background` - Fondo principal
- `theme.Surface` - Superficies elevadas
- `theme.Primary` - Color primario (botones, enlaces)
- `theme.Secondary` - Color secundario
- `theme.Accent` - Color de acento
- `theme.Success` - Verde para éxito
- `theme.Warning` - Amarillo para advertencias
- `theme.Error` - Rojo para errores
- `theme.Text` - Texto principal
- `theme.TextSecondary` - Texto secundario

### Métodos de API Simplificada
- `Designs.Simple.Setup(theme, options)` - Configuración inicial
- `Designs.Simple.Create(type, parent, config)` - Crear componente
- `Designs.Simple.ApplyGlobalTheme(themeName)` - Cambiar tema global
- `Designs.Simple.CustomTheme(color, name)` - Crear tema personalizado

### Tipos de Componentes
- `"Button"` - Botón moderno
- `"Card"` - Tarjeta elegante
- `"Toggle"` - Interruptor avanzado
- `"Slider"` - Control deslizante
- `"Notification"` - Notificación

---

## 🤝 Contribuir

¿Quieres agregar nuevos temas o componentes? El sistema está diseñado para ser extensible:

1. **Nuevos Temas**: Agrega entries a `Designs.Themes`
2. **Nuevos Componentes**: Agrega functions a `Designs.Presets`
3. **Nuevos Efectos**: Agrega functions a `Designs.Effects`
4. **Nuevas Animaciones**: Agrega functions a `Designs.Animations`

---

## 📄 Licencia

Este sistema es parte de **EvolutionLibs** y está diseñado para uso en proyectos de Roblox.

---

*🎨 Creado con amor para la comunidad de desarrolladores de Roblox*
