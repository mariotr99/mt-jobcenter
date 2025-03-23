Config = {}


Config.JobCenterZone = {
    coords = vector3(-1293.48, -570.69, 30.57),
    length = 4.0,
    width = 4.0,
    minZ = 29.0,
    maxZ = 33.0,
    heading = 0
}

Config.JobCenterNPC = {
    model = "cs_bankman", -- Puedes cambiarlo a cualquier modelo válido de ped
    coords = vector4(-1293.48, -570.69, 30.57, 346.96),
    scenario = "WORLD_HUMAN_CLIPBOARD" -- O una animación como "amb@world_human_hang_out_street@male_c@base"
}


Config.Jobs = {
    {
        job = "police",
        label = "Policía",
        description = "Protege y sirve a la comunidad.",
        text = [[
    El Departamento de Policía tiene la responsabilidad de garantizar la seguridad y el orden público en la ciudad. Sus agentes actúan ante delitos, conflictos civiles y situaciones de emergencia.
    
    Los oficiales patrullan las calles, responden a llamadas de auxilio, realizan investigaciones y colaboran con otras instituciones para mantener la paz.
    
    Este trabajo requiere disciplina, compromiso, criterio en la toma de decisiones y respeto por la ley. Es una profesión de alto impacto social que ofrece oportunidades de crecimiento dentro de la estructura policial.
        ]],
        image = "lspd.png"
    },
    
    {
        job = "ambulance",
        label = "Ambulancia",
        description = "Responde a emergencias médicas.",
        text = [[
    El personal médico de emergencias brinda atención inmediata a quienes lo necesitan. Desde accidentes de tráfico hasta emergencias en la vía pública, su misión es salvar vidas.
    
    Los paramédicos están entrenados en primeros auxilios, reanimación, transporte seguro de pacientes y uso de equipamiento médico.
    
    Este trabajo exige compromiso, rapidez de respuesta y vocación de servicio. Si tu objetivo es cuidar de los demás, este es tu lugar en la ciudad.
        ]],
        image = "lsfd.png"
    },
    
    {
        job = "mechanic",
        label = "Mecánico",
        description = "Repara y mantiene vehículos.",
        text = [[
    Los mecánicos son una parte esencial del funcionamiento de la ciudad. Se encargan de diagnosticar y reparar todo tipo de vehículos, desde autos particulares hasta unidades de emergencia.
    
    Además de las reparaciones básicas, tienen conocimientos en modificación, pintura y personalización estética o funcional de los vehículos.
    
    Trabajar como mecánico requiere precisión, responsabilidad y habilidades técnicas. Es un rol ideal para quienes disfrutan del trabajo manual y tienen pasión por los motores.
        ]],
        image = "LSC.png"
    }
    
}
