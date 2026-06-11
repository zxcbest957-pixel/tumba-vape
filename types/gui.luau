export type TumbaVapeSlider = {
    Value: any,
    Object: Frame
}
export type TumbaVapeDropdown = TumbaVapeSlider

export type TumbaVapeToggle = {
    Enabled: boolean,
    Toggle: (self: TumbaVapeToggle, ...any) -> (),
    Object: Frame,
    Clean: (self: TumbaVapeToggle, any) -> RBXScriptConnection
}

export type TumbaVapeModule = TumbaVapeToggle & {
    CreateSlider: (...any) -> TumbaVapeSlider, 
    CreateToggle: (...any) -> TumbaVapeToggle,
    CreateDropdown: (...any) -> TumbaVapeDropdown,
    CreateButton: (...any) -> ()
}

export type TumbaVapeCategory = {
    CreateModule: (self: TumbaVapeCategory, any) -> TumbaVapeModule
}