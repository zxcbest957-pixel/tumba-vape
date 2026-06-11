export type Tumba VapeSlider = {
    Value: any,
    Object: Frame
}
export type Tumba VapeDropdown = Tumba VapeSlider

export type Tumba VapeToggle = {
    Enabled: boolean,
    Toggle: (self: Tumba VapeToggle, ...any) -> (),
    Object: Frame,
    Clean: (self: Tumba VapeToggle, any) -> RBXScriptConnection
}

export type Tumba VapeModule = Tumba VapeToggle & {
    CreateSlider: (...any) -> Tumba VapeSlider, 
    CreateToggle: (...any) -> Tumba VapeToggle,
    CreateDropdown: (...any) -> Tumba VapeDropdown,
    CreateButton: (...any) -> ()
}

export type Tumba VapeCategory = {
    CreateModule: (self: Tumba VapeCategory, any) -> Tumba VapeModule
}