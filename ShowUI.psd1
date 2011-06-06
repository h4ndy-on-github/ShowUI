@{
    <# 
    Version History: 
        0.1 - 
            Initial Checkin - switched to compiled code generator
                Improved load (2-5 seconds to .4 seconds)
                Improved memory footprint of 2nd load(now < 100MB)
                Dented memory footprint of first load (now ~10MB more)
        0.1.1 - 
            Changed C# parameter genarator default to avoid ValueFromPipelineByPropertyName 
            (broke the common case of New-Label { "hello" } )
            Significantly brought down the number of useless generated commands.  
                281 New- commands, versus 676 in WPK
        0.1.2 - 
            Updated WPF code generations rules:
            - Fixed the bug with -RoutedEvent (they were being treated like dependencyproperties)
            - Just a little bit more culling 
                (will no longer generate subclasses of [Windows.Media.ImagingBitmapEncoder])
                275 New- commands, versus 676 in WPK and 281 in 0.1.2
        0.1.3 -
            - Removing ErrorActionStop (made phantom UIs more likely)
            - Removing the "extra" handler
            - Switched to generating code from memory, not a file (to avoid potential file locks)
            - Switched to -Language CSharpVersion3 and got rid of backing fields
            - Adding Defaults for Border and GradientStops as positional parameters
            - Re-adding primitives to the generated UI list            
        0.1.4 - 
            - Re-adding -Extra handler from Add-EventHandler (better error default)
            - Added "core" code to Add-EventHandler, which makes it easier to locate items
            - Added Get-ParentControl
            - Completely refactored / fixed Get-ChildControl (now much faster) 
            - Made "XAML input" only happen if the option is turned on (improves perf of Set Property)           
        0.1.5 -
            - Correcting foolishness and adding Get-ParentControl.ps1 and Close-Control.ps1            
        0.1.6 -
            - Updating Get-ChildControl to handle content (as it used to)
            - Fixing the way Get-ChildControl handles -PeekIntoNestedControl
            - Updating Show-Window to include event handler cleanup
            - Updating Show-Window to include scriptblock parameter:
                - The scriptblock is run
                - If it produces a visual, that becomes content
                - Otherwise, the result is piped to Out-String
                - Then that becomes the content
                - And the fontfamily attempts to become Consolas (cute fixed width font)                        
                - Errors show in red
            - Added Show-UI, Show-BootsWindow aliases            
            - Fixed WPF Job to wait for window creation 
                (New-Window -asJob | Update-WPFJob -Command { $window.Content = Get-Random } now works)
            - Fixed Update-WPFJob to allow for updating jobs created in the console host
            - Added 'Async' alias for -AsJob in Show-Window for Boots backwards compatibility        
        0.5 -
            - Renamed Show-Ui to ShowUi .psm1/.psd1 
            - Moved directory structure around
            - Dynamically compiled -AsJob
            - Made attempts at making Receive-Job worked
            - More adjusting of the type list.  
                MarkupExtension is currently back in (for databinding)
            - Attempted to make DataBinding coercion work for Set Property
            - Fixed -ControlName property
            - Added dependency properties to support Styles
            - Added -VisualStyle property
            - Fixed & Improved Error Handling
                Made errors output correctly in the current runspace.
                Added helper information to error (name of control, name of handler, line info)
            - Improved performance of Add-EventHandler
                Consolidated all automatically created code into one script block
            - Added default UID on all framework elements
            - Added Select-Date common control
            - Added OutputType to all generated commands            
            - Made -Data parameter first for New-Path
            - Made -Path parameter first for New-Binding
    #>
    ModuleVersion = '1.0'
    Author='Joel Bennett, James Brundage, & Doug Finke'
    Copyright='Start-Automating 2011'    
    Description='Show-UI is a module to help you write user interfaces to interact with PowerShell'
    Guid='ff975fb0-3731-4312-b32d-830fd3185193'
    ModuleToProcess='ShowUI.psm1'
    FormatsToProcess='ShowUI.Formats.ps1xml'    
    ScriptsToProcess='Get-ReferencedCommand.ps1','Get-UiCommand.ps1'    
} 

