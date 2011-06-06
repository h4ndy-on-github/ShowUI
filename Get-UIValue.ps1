function Get-UIValue
{    
    param(
    [Parameter(ValueFromPipeline=$true)]
    [Windows.FrameworkElement]    
    $Ui,
    
    [Switch]
    $IncludeEmptyValue,
    
    [switch]
    $DoNotAddUINoteProperty    
    )
    
    begin {
        Set-StrictMode -Off
        function MaybeAddUIProperty {
            param($ui)
            if (-not $DoNotAddUINoteProperty) {
                $newValue = Add-Member -InputObject $newValue NoteProperty UI $Ui -PassThru 
            }
        }
         
    }
    
    process {
        if ($UI.Tag) {
            $newValue = $UI.Tag
            . MaybeAddUIProperty $ui
            return $newValue
        } elseif ($Ui.SelectedItems) {
            $newValue = $UI.SelectedItems
            . MaybeAddUIProperty $ui
            return $newValue
        } elseif ($ui.GetType().GetProperty("IsChecked")){ 
            $newValue = $UI.IsChecked
            . MaybeAddUIProperty $ui
            return $newValue
        } elseif ($ui.Text) {
            $newValue = $UI.Text
            . MaybeAddUIProperty $ui
            return $newValue
        } else {
            $uiValues = @{} + (Get-ChildControl -OutputNamedControl -Control $ui)
            foreach ($keyName in @($uiValues.Keys)) {
                $tag = $uiValues[$keyName].Tag
                $text = $uiValues[$keyName].Text
                $selectedItems = $uiValues[$keyName].SelectedItems
                $isCheckedExists =$uiValues[$keyName].GetType().GetProperty("IsChecked")
                $checked = $uiValues[$keyName].ISChecked
                if ($tag) {
                    $newValue = $tag                    
                    . MaybeAddUIProperty $uiValues[$keyName]
                    $uiValues[$keyName] = $newValue
                } elseif ($selectedItems) {
                    $newValue = $selectedItems
                    . MaybeAddUIProperty $uiValues[$keyName]
                    $uiValues[$keyName] = $newValue
                } elseif ($isCheckedExists) {
                    $newValue = $checked
                    . MaybeAddUIProperty $uiValues[$keyName]
                    $uiValues[$keyName] = $newValue
                } elseif ($text) {
                    $newValue = $text               
                    . MaybeAddUIProperty $uiValues[$keyName]
                    $uiValues[$keyName] = $newValue
                } else {
                    if (-not $IncludeEmptyValue) {
                        $null = $uiValues.Remove($keyName)
                    } else {
                        $uiValues[$keyName] = $null
                    }                    
                }                
            }
            $uiValues
        }
    }
}