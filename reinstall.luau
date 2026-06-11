local cloneref = cloneref or function(ref: any)
    return ref
end

if isfolder('tumbavape') then
    delfolder('tumbavape')
end

cloneref(game:GetService('StarterGui')):SetCore('SendNotification', {
    Title = 'Tumba Vape',
    Text = 'Successfully reinstalled Tumba Vape, Please rejoin the game to take effect',
    Duration = 20
})