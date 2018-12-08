# Synteza (.v -> .ngc)
xst -ifn bestial.xst
# Linkowanie (.ngc -> .ngd)
ngdbuild bestial -uc bestial.ucf
# Tłumaczenie na prymitywy dostępne w układzie Spartan 3E (.ngd -> .ncd)
map bestial
# Place and route (.ncd -> lepszy .ncd)
par -w bestial.ncd bestial_par.ncd
# Generowanie finalnego bitstreamu (.ncd -> .bit)
bitgen -w bestial_par.ncd -g StartupClk:JTAGClk -g LCK_cycle:3
