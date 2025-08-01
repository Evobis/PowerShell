<#
    .SYNOPSIS
        Using the Microsoft.Graph PowerShell module, this function will add permissions to a Managed Identity
    .Description
        Using the Microsoft.Graph PowerShell module, this function will add permissions to a Managed Identity, currently only SharePoint and Graph permissions are supported
    .NOTES
        Author: Dan Toft
#>



function Add-EBPermissionsToManagedIdentity {
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [string]$ManagedIdentityObjectId,

        [Parameter()]    
        [Alias("SharePointScopesApplication")]
        [ValidateSet([SharePoint])]
        [string[]]$SharePointScopes,
    
        [Parameter()]    
        [Alias("GraphScopesApplication")]
        [ValidateSet([Graph])]
        [string[]]$GraphScopes,

        [Parameter()]    
        [ValidateSet([SharePoint])]
        [string[]]$SharePointScopesDelegated,
    
        [Parameter()]    
        [ValidateSet([Graph])]
        [string[]]$GraphScopesDelegated
    )



    Write-Host "Adding permissions to Managed Identity '$ManagedIdentityObjectId'"
    
    if ($GraphScopes.Length -eq 0 -and $SharePointScopes.Length -eq 0 -and $GraphScopesDelegated.Length -eq 0 -and $SharePointScopesDelegated.Length -eq 0) {
        throw "No scopes provided";
    }


    if ($GraphScopes.Length -gt 0) {
        $graphServicePrincipal = Get-MgServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'" -Property Id, AppRoles
        foreach ($roleAssignment in $GraphScopes) {
            Add-EBRoleAssignment -ServicePrincipal $graphServicePrincipal -ManagedIdentityObjectId $ManagedIdentityObjectId -RoleAssignment $roleAssignment
        }
    }

    if ($SharePointScopes.Length -gt 0) {
        $sharePointServicePrincipal = Get-MgServicePrincipal -Filter "DisplayName eq 'Office 365 SharePoint Online'" -Property Id, AppRoles
        foreach ($roleAssignment in $SharePointScopes) {
            Add-EBRoleAssignment -ServicePrincipal $sharePointServicePrincipal -ManagedIdentityObjectId $ManagedIdentityObjectId -RoleAssignment $roleAssignment
        }
    }

    if ($GraphScopesDelegated.Length -gt 0) {
        $graphServicePrincipal = Get-MgServicePrincipal -Filter "DisplayName eq 'Microsoft Graph'" -Property Id, AppRoles
        foreach ($roleAssignment in $GraphScopesDelegated) {
            Add-EBRoleAssignment -ServicePrincipal $graphServicePrincipal -ManagedIdentityObjectId $ManagedIdentityObjectId -RoleAssignment $roleAssignment -Delegated
        }
    }

    if ($SharePointScopesDelegated.Length -gt 0) {
        $sharePointServicePrincipal = Get-MgServicePrincipal -Filter "DisplayName eq 'Office 365 SharePoint Online'" -Property Id, AppRoles
        foreach ($roleAssignment in $SharePointScopesDelegated) {
            Add-EBRoleAssignment -ServicePrincipal $sharePointServicePrincipal -ManagedIdentityObjectId $ManagedIdentityObjectId -RoleAssignment $roleAssignment -Delegated
        }
    }
    
    Write-Host "`nListing all assignments for $ManagedIdentityObjectId`n"
    
    Write-Host "`nApplication"
    $allAssignmentsApp = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId | Group-Object -Property ResourceDisplayName
    foreach ($group in $allAssignmentsApp) {
        Write-Host "> $($group.Name)"
        foreach ($assignment in $group.Group) {
            $appRole = get-mgserviceprincipal -ServicePrincipalId $assignment.ResourceId | select -ExpandProperty AppRoles | Where-Object Id -eq $assignment.AppRoleId
            Write-Host "`t> $($appRole.Value)"
        }
    }

    Write-Host "`nDelegated"
    $allDelegatedassignments = Get-MgOauth2PermissionGrant -Filter "clientId eq '$ManagedIdentityObjectId' and consentType eq 'AllPrincipals'" 
    foreach ($group in $allDelegatedassignments) {
        $principal = Get-MgServicePrincipal -ServicePrincipalId $group.ResourceId
        Write-Host "> $($principal.DisplayName)"
        foreach ($assignment in $allDelegatedassignments.Scope -split " ") {
            Write-Host "`t> $($assignment)"
        }
    }

    Write-Host "`nFinished adding permissions to Managed Identity '$ManagedIdentityObjectId'"

}

class Graph : System.Management.Automation.IValidateSetValuesGenerator {
    [System.String[]] GetValidValues() {
        $PossibleScopes = @(
            "AccessReview.Read.All"
            "AccessReview.ReadWrite.All"
            "AccessReview.ReadWrite.Membership"
            "Acronym.Read.All"
            "AdministrativeUnit.Read.All"
            "AdministrativeUnit.ReadWrite.All"
            "AgentApplication.Create"
            "AgentIdentity.Create"
            "Agreement.Read.All"
            "Agreement.ReadWrite.All"
            "AgreementAcceptance.Read.All"
            "AiEnterpriseInteraction.Read.All"
            "APIConnectors.Read.All"
            "APIConnectors.ReadWrite.All"
            "AppCatalog.Read.All"
            "AppCatalog.ReadWrite.All"
            "Application-RemoteDesktopConfig.ReadWrite.All"
            "Application.Read.All"
            "Application.ReadWrite.All"
            "Application.ReadWrite.OwnedBy"
            "AppRoleAssignment.ReadWrite.All"
            "ApprovalSolution.Read.All"
            "ApprovalSolution.ReadWrite.All"
            "AttackSimulation.Read.All"
            "AttackSimulation.ReadWrite.All"
            "AuditActivity.Read"
            "AuditActivity.Write"
            "AuditLog.Read.All"
            "AuditLogsQuery-CRM.Read.All"
            "AuditLogsQuery-Endpoint.Read.All"
            "AuditLogsQuery-Entra.Read.All"
            "AuditLogsQuery-Exchange.Read.All"
            "AuditLogsQuery-OneDrive.Read.All"
            "AuditLogsQuery-SharePoint.Read.All"
            "AuditLogsQuery.Read.All"
            "AuthenticationContext.Read.All"
            "AuthenticationContext.ReadWrite.All"
            "BackupRestore-Configuration.Read.All"
            "BackupRestore-Configuration.ReadWrite.All"
            "BackupRestore-Control.Read.All"
            "BackupRestore-Control.ReadWrite.All"
            "BackupRestore-Monitor.Read.All"
            "BackupRestore-Restore.Read.All"
            "BackupRestore-Restore.ReadWrite.All"
            "BackupRestore-Search.Read.All"
            "BillingConfiguration.ReadWrite.All"
            "BitlockerKey.Read.All"
            "BitlockerKey.ReadBasic.All"
            "Bookings.Manage.All"
            "Bookings.Read.All"
            "Bookings.ReadWrite.All"
            "BookingsAppointment.ReadWrite.All"
            "Bookmark.Read.All"
            "BrowserSiteLists.Read.All"
            "BrowserSiteLists.ReadWrite.All"
            "BusinessScenarioConfig.Read.OwnedBy"
            "BusinessScenarioConfig.ReadWrite.OwnedBy"
            "BusinessScenarioData.Read.OwnedBy"
            "BusinessScenarioData.ReadWrite.OwnedBy"
            "Calendars.Read"
            "Calendars.ReadBasic.All"
            "Calendars.ReadWrite"
            "CallDelegation.Read.All"
            "CallDelegation.ReadWrite.All"
            "CallEvents-Emergency.Read.All"
            "CallEvents.Read.All"
            "CallRecord-PstnCalls.Read.All"
            "CallRecords.Read.All"
            "Calls.AccessMedia.All"
            "Calls.Initiate.All"
            "Calls.InitiateGroupCall.All"
            "Calls.JoinGroupCall.All"
            "Calls.JoinGroupCallAsGuest.All"
            "ChangeManagement.Read.All"
            "Channel.Create"
            "Channel.Delete.All"
            "Channel.ReadBasic.All"
            "ChannelMember.Read.All"
            "ChannelMember.ReadWrite.All"
            "ChannelMessage.Read.All"
            "ChannelMessage.UpdatePolicyViolation.All"
            "ChannelSettings.Read.All"
            "ChannelSettings.ReadWrite.All"
            "Chat.Create"
            "Chat.ManageDeletion.All"
            "Chat.Read.All"
            "Chat.Read.WhereInstalled"
            "Chat.ReadBasic.All"
            "Chat.ReadBasic.WhereInstalled"
            "Chat.ReadWrite.All"
            "Chat.ReadWrite.WhereInstalled"
            "Chat.UpdatePolicyViolation.All"
            "ChatMember.Read.All"
            "ChatMember.Read.WhereInstalled"
            "ChatMember.ReadWrite.All"
            "ChatMember.ReadWrite.WhereInstalled"
            "ChatMessage.Read.All"
            "CloudApp-Discovery.Read.All"
            "CloudPC.Read.All"
            "CloudPC.ReadWrite.All"
            "Community.Read.All"
            "Community.ReadWrite.All"
            "ConfigurationMonitoring.Read.All"
            "ConfigurationMonitoring.ReadWrite.All"
            "ConsentRequest.Read.All"
            "ConsentRequest.ReadWrite.All"
            "Contacts.Read"
            "Contacts.ReadWrite"
            "Content.Process.All"
            "Content.Process.User"
            "ContentActivity.Read"
            "ContentActivity.Write"
            "CrossTenantInformation.ReadBasic.All"
            "CrossTenantUserProfileSharing.Read.All"
            "CrossTenantUserProfileSharing.ReadWrite.All"
            "CustomAuthenticationExtension.Read.All"
            "CustomAuthenticationExtension.ReadWrite.All"
            "CustomAuthenticationExtension.Receive.Payload"
            "CustomDetection.Read.All"
            "CustomDetection.ReadWrite.All"
            "CustomSecAttributeAssignment.Read.All"
            "CustomSecAttributeAssignment.ReadWrite.All"
            "CustomSecAttributeAuditLogs.Read.All"
            "CustomSecAttributeDefinition.Read.All"
            "CustomSecAttributeDefinition.ReadWrite.All"
            "CustomSecAttributeProvisioning.Read.All"
            "CustomSecAttributeProvisioning.ReadWrite.All"
            "CustomTags.Read.All"
            "CustomTags.ReadWrite.All"
            "DelegatedAdminRelationship.Read.All"
            "DelegatedAdminRelationship.ReadWrite.All"
            "DelegatedPermissionGrant.Read.All"
            "DelegatedPermissionGrant.ReadWrite.All"
            "Device.Read.All"
            "Device.ReadWrite.All"
            "DeviceLocalCredential.Read.All"
            "DeviceLocalCredential.ReadBasic.All"
            "DeviceManagementApps.Read.All"
            "DeviceManagementApps.ReadWrite.All"
            "DeviceManagementCloudCA.Read.All"
            "DeviceManagementCloudCA.ReadWrite.All"
            "DeviceManagementConfiguration.Read.All"
            "DeviceManagementConfiguration.ReadWrite.All"
            "DeviceManagementManagedDevices.PrivilegedOperations.All"
            "DeviceManagementManagedDevices.Read.All"
            "DeviceManagementManagedDevices.ReadWrite.All"
            "DeviceManagementRBAC.Read.All"
            "DeviceManagementRBAC.ReadWrite.All"
            "DeviceManagementScripts.Read.All"
            "DeviceManagementScripts.ReadWrite.All"
            "DeviceManagementServiceConfig.Read.All"
            "DeviceManagementServiceConfig.ReadWrite.All"
            "DeviceTemplate.Create"
            "DeviceTemplate.Read.All"
            "DeviceTemplate.ReadWrite.All"
            "Directory.Read.All"
            "Directory.ReadWrite.All"
            "DirectoryRecommendations.Read.All"
            "DirectoryRecommendations.ReadWrite.All"
            "Domain-InternalFederation.Read.All"
            "Domain-InternalFederation.ReadWrite.All"
            "Domain.Read.All"
            "Domain.ReadWrite.All"
            "eDiscovery.Read.All"
            "eDiscovery.ReadWrite.All"
            "EduAdministration.Read.All"
            "EduAdministration.ReadWrite.All"
            "EduAssignments.Read.All"
            "EduAssignments.ReadBasic.All"
            "EduAssignments.ReadWrite.All"
            "EduAssignments.ReadWriteBasic.All"
            "EduCurricula.Read.All"
            "EduCurricula.ReadWrite.All"
            "EduReports-Reading.Read.All"
            "EduReports-Reading.ReadAnonymous.All"
            "EduReports-Reflect.Read.All"
            "EduReports-Reflect.ReadAnonymous.All"
            "EduRoster.Read.All"
            "EduRoster.ReadBasic.All"
            "EduRoster.ReadWrite.All"
            "EngagementConversation.Migration.All"
            "EngagementMeetingConversation.Read.All"
            "EngagementRole.Read.All"
            "EngagementRole.ReadWrite.All"
            "EntitlementManagement.Read.All"
            "EntitlementManagement.ReadWrite.All"
            "EventListener.Read.All"
            "EventListener.ReadWrite.All"
            "ExternalConnection.Read.All"
            "ExternalConnection.ReadWrite.All"
            "ExternalConnection.ReadWrite.OwnedBy"
            "ExternalItem.Read.All"
            "ExternalItem.ReadWrite.All"
            "ExternalItem.ReadWrite.OwnedBy"
            "ExternalUserProfile.Read.All"
            "ExternalUserProfile.ReadWrite.All"
            "FileIngestion.Ingest"
            "FileIngestionHybridOnboarding.Manage"
            "Files.Read.All"
            "Files.ReadWrite.All"
            "Files.ReadWrite.AppFolder"
            "Files.SelectedOperations.Selected"
            "FileStorageContainer.Selected"
            "Group-Conversation.Read.All"
            "Group-Conversation.ReadWrite.All"
            "Group.Create"
            "Group.Read.All"
            "Group.ReadWrite.All"
            "GroupMember.Read.All"
            "GroupMember.ReadWrite.All"
            "GroupSettings.Read.All"
            "GroupSettings.ReadWrite.All"
            "HealthMonitoringAlert.Read.All"
            "HealthMonitoringAlert.ReadWrite.All"
            "HealthMonitoringAlertConfig.Read.All"
            "HealthMonitoringAlertConfig.ReadWrite.All"
            "IdentityProvider.Read.All"
            "IdentityProvider.ReadWrite.All"
            "IdentityRiskEvent.Read.All"
            "IdentityRiskEvent.ReadWrite.All"
            "IdentityRiskyServicePrincipal.Read.All"
            "IdentityRiskyServicePrincipal.ReadWrite.All"
            "IdentityRiskyUser.Read.All"
            "IdentityRiskyUser.ReadWrite.All"
            "IdentityUserFlow.Read.All"
            "IdentityUserFlow.ReadWrite.All"
            "IndustryData-DataConnector.Read.All"
            "IndustryData-DataConnector.ReadWrite.All"
            "IndustryData-DataConnector.Upload"
            "IndustryData-InboundFlow.Read.All"
            "IndustryData-InboundFlow.ReadWrite.All"
            "IndustryData-OutboundFlow.Read.All"
            "IndustryData-OutboundFlow.ReadWrite.All"
            "IndustryData-ReferenceDefinition.Read.All"
            "IndustryData-ReferenceDefinition.ReadWrite.All"
            "IndustryData-Run.Read.All"
            "IndustryData-Run.Start"
            "IndustryData-SourceSystem.Read.All"
            "IndustryData-SourceSystem.ReadWrite.All"
            "IndustryData-TimePeriod.Read.All"
            "IndustryData-TimePeriod.ReadWrite.All"
            "IndustryData.ReadBasic.All"
            "InformationProtectionConfig.Read.All"
            "InformationProtectionContent.Sign.All"
            "InformationProtectionContent.Write.All"
            "InformationProtectionPolicy.Read.All"
            "Insights-UserMetric.Read.All"
            "LearningAssignedCourse.Read.All"
            "LearningAssignedCourse.ReadWrite.All"
            "LearningContent.Read.All"
            "LearningContent.ReadWrite.All"
            "LearningSelfInitiatedCourse.Read.All"
            "LearningSelfInitiatedCourse.ReadWrite.All"
            "LicenseAssignment.Read.All"
            "LicenseAssignment.ReadWrite.All"
            "LifecycleWorkflows-CustomExt.Read.All"
            "LifecycleWorkflows-CustomExt.ReadWrite.All"
            "LifecycleWorkflows-Reports.Read.All"
            "LifecycleWorkflows-Workflow.Activate"
            "LifecycleWorkflows-Workflow.Read.All"
            "LifecycleWorkflows-Workflow.ReadBasic.All"
            "LifecycleWorkflows-Workflow.ReadWrite.All"
            "LifecycleWorkflows.Read.All"
            "LifecycleWorkflows.ReadWrite.All"
            "ListItems.SelectedOperations.Selected"
            "Lists.SelectedOperations.Selected"
            "Mail.Read"
            "Mail.ReadBasic"
            "Mail.ReadBasic.All"
            "Mail.ReadWrite"
            "Mail.Send"
            "MailboxFolder.Read.All"
            "MailboxFolder.ReadWrite.All"
            "MailboxItem.ImportExport.All"
            "MailboxItem.Read.All"
            "MailboxSettings.Read"
            "MailboxSettings.ReadWrite"
            "Member.Read.Hidden"
            "MultiTenantOrganization.Read.All"
            "MultiTenantOrganization.ReadBasic.All"
            "MultiTenantOrganization.ReadWrite.All"
            "MutualTlsOauthConfiguration.Read.All"
            "MutualTlsOauthConfiguration.ReadWrite.All"
            "NetworkAccess-Reports.Read.All"
            "NetworkAccess.Read.All"
            "NetworkAccess.ReadWrite.All"
            "NetworkAccessBranch.Read.All"
            "NetworkAccessBranch.ReadWrite.All"
            "NetworkAccessPolicy.Read.All"
            "NetworkAccessPolicy.ReadWrite.All"
            "Notes.Read.All"
            "Notes.ReadWrite.All"
            "OnlineMeetingAiInsight.Read.All"
            "OnlineMeetingAiInsight.Read.Chat"
            "OnlineMeetingArtifact.Read.All"
            "OnlineMeetingRecording.Read.All"
            "OnlineMeetings.Read.All"
            "OnlineMeetings.ReadWrite.All"
            "OnlineMeetingTranscript.Read.All"
            "OnPremDirectorySynchronization.Read.All"
            "OnPremDirectorySynchronization.ReadWrite.All"
            "OnPremisesPublishingProfiles.ReadWrite.All"
            "Organization.Read.All"
            "Organization.ReadWrite.All"
            "OrganizationalBranding.Read.All"
            "OrganizationalBranding.ReadWrite.All"
            "OrgContact.Read.All"
            "OrgSettings-AppsAndServices.Read.All"
            "OrgSettings-AppsAndServices.ReadWrite.All"
            "OrgSettings-DynamicsVoice.Read.All"
            "OrgSettings-DynamicsVoice.ReadWrite.All"
            "OrgSettings-Forms.Read.All"
            "OrgSettings-Forms.ReadWrite.All"
            "OrgSettings-Microsoft365Install.Read.All"
            "OrgSettings-Microsoft365Install.ReadWrite.All"
            "OrgSettings-Todo.Read.All"
            "OrgSettings-Todo.ReadWrite.All"
            "PartnerBilling.Read.All"
            "PartnerSecurity.Read.All"
            "PartnerSecurity.ReadWrite.All"
            "PendingExternalUserProfile.Read.All"
            "PendingExternalUserProfile.ReadWrite.All"
            "People.Read.All"
            "PeopleSettings.Read.All"
            "PeopleSettings.ReadWrite.All"
            "Place.Read.All"
            "PlaceDevice.Read.All"
            "PlaceDevice.ReadWrite.All"
            "PlaceDeviceTelemetry.ReadWrite.All"
            "Policy.Read.All"
            "Policy.Read.AuthenticationMethod"
            "Policy.Read.ConditionalAccess"
            "Policy.Read.DeviceConfiguration"
            "Policy.Read.IdentityProtection"
            "Policy.Read.PermissionGrant"
            "Policy.ReadWrite.AccessReview"
            "Policy.ReadWrite.ApplicationConfiguration"
            "Policy.ReadWrite.AuthenticationFlows"
            "Policy.ReadWrite.AuthenticationMethod"
            "Policy.ReadWrite.Authorization"
            "Policy.ReadWrite.ConditionalAccess"
            "Policy.ReadWrite.ConsentRequest"
            "Policy.ReadWrite.CrossTenantAccess"
            "Policy.ReadWrite.CrossTenantCapability"
            "Policy.ReadWrite.DeviceConfiguration"
            "Policy.ReadWrite.ExternalIdentities"
            "Policy.ReadWrite.FeatureRollout"
            "Policy.ReadWrite.FedTokenValidation"
            "Policy.ReadWrite.IdentityProtection"
            "Policy.ReadWrite.PermissionGrant"
            "Policy.ReadWrite.SecurityDefaults"
            "Policy.ReadWrite.TrustFramework"
            "Presence.Read.All"
            "Presence.ReadWrite.All"
            "Printer.Read.All"
            "Printer.ReadWrite.All"
            "PrintJob.Manage.All"
            "PrintJob.Read.All"
            "PrintJob.ReadBasic.All"
            "PrintJob.ReadWrite.All"
            "PrintJob.ReadWriteBasic.All"
            "PrintSettings.Read.All"
            "PrintTaskDefinition.ReadWrite.All"
            "PrivilegedAccess.Read.AzureAD"
            "PrivilegedAccess.Read.AzureADGroup"
            "PrivilegedAccess.Read.AzureResources"
            "PrivilegedAccess.ReadWrite.AzureAD"
            "PrivilegedAccess.ReadWrite.AzureADGroup"
            "PrivilegedAccess.ReadWrite.AzureResources"
            "PrivilegedAssignmentSchedule.Read.AzureADGroup"
            "PrivilegedAssignmentSchedule.ReadWrite.AzureADGroup"
            "PrivilegedAssignmentSchedule.Remove.AzureADGroup"
            "PrivilegedEligibilitySchedule.Read.AzureADGroup"
            "PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup"
            "PrivilegedEligibilitySchedule.Remove.AzureADGroup"
            "ProfilePhoto.Read.All"
            "ProfilePhoto.ReadWrite.All"
            "ProgramControl.Read.All"
            "ProgramControl.ReadWrite.All"
            "ProtectionScopes.Compute.All"
            "ProtectionScopes.Compute.User"
            "ProvisioningLog.Read.All"
            "PublicKeyInfrastructure.Read.All"
            "PublicKeyInfrastructure.ReadWrite.All"
            "QnA.Read.All"
            "RecordsManagement.Read.All"
            "RecordsManagement.ReadWrite.All"
            "Reports.Read.All"
            "ReportSettings.Read.All"
            "ReportSettings.ReadWrite.All"
            "ResourceSpecificPermissionGrant.ReadForChat.All"
            "ResourceSpecificPermissionGrant.ReadForTeam.All"
            "ResourceSpecificPermissionGrant.ReadForUser.All"
            "RiskPreventionProviders.Read.All"
            "RiskPreventionProviders.ReadWrite.All"
            "RoleAssignmentSchedule.Read.Directory"
            "RoleAssignmentSchedule.ReadWrite.Directory"
            "RoleAssignmentSchedule.Remove.Directory"
            "RoleEligibilitySchedule.Read.Directory"
            "RoleEligibilitySchedule.ReadWrite.Directory"
            "RoleEligibilitySchedule.Remove.Directory"
            "RoleManagement.Read.All"
            "RoleManagement.Read.CloudPC"
            "RoleManagement.Read.Defender"
            "RoleManagement.Read.Directory"
            "RoleManagement.Read.Exchange"
            "RoleManagement.ReadWrite.CloudPC"
            "RoleManagement.ReadWrite.Defender"
            "RoleManagement.ReadWrite.Directory"
            "RoleManagement.ReadWrite.Exchange"
            "RoleManagementAlert.Read.Directory"
            "RoleManagementAlert.ReadWrite.Directory"
            "RoleManagementPolicy.Read.AzureADGroup"
            "RoleManagementPolicy.Read.Directory"
            "RoleManagementPolicy.ReadWrite.AzureADGroup"
            "RoleManagementPolicy.ReadWrite.Directory"
            "Schedule-WorkingTime.ReadWrite.All"
            "Schedule.Read.All"
            "Schedule.ReadWrite.All"
            "SchedulePermissions.ReadWrite.All"
            "SearchConfiguration.Read.All"
            "SearchConfiguration.ReadWrite.All"
            "SecurityActions.Read.All"
            "SecurityActions.ReadWrite.All"
            "SecurityAlert.Read.All"
            "SecurityAlert.ReadWrite.All"
            "SecurityAnalyzedMessage.Read.All"
            "SecurityAnalyzedMessage.ReadWrite.All"
            "SecurityEvents.Read.All"
            "SecurityEvents.ReadWrite.All"
            "SecurityIdentitiesAccount.Read.All"
            "SecurityIdentitiesActions.ReadWrite.All"
            "SecurityIdentitiesHealth.Read.All"
            "SecurityIdentitiesHealth.ReadWrite.All"
            "SecurityIdentitiesSensors.Read.All"
            "SecurityIdentitiesSensors.ReadWrite.All"
            "SecurityIdentitiesUserActions.Read.All"
            "SecurityIdentitiesUserActions.ReadWrite.All"
            "SecurityIncident.Read.All"
            "SecurityIncident.ReadWrite.All"
            "SensitivityLabel.Evaluate"
            "SensitivityLabel.Evaluate.All"
            "SensitivityLabel.Read"
            "SensitivityLabels.Read.All"
            "ServiceActivity-Exchange.Read.All"
            "ServiceActivity-Microsoft365Web.Read.All"
            "ServiceActivity-OneDrive.Read.All"
            "ServiceActivity-Teams.Read.All"
            "ServiceHealth.Read.All"
            "ServiceMessage.Read.All"
            "ServicePrincipalEndpoint.Read.All"
            "ServicePrincipalEndpoint.ReadWrite.All"
            "SharePointTenantSettings.Read.All"
            "SharePointTenantSettings.ReadWrite.All"
            "ShortNotes.Read.All"
            "ShortNotes.ReadWrite.All"
            "SignInIdentifier.Read.All"
            "SignInIdentifier.ReadWrite.All"
            "Sites.Archive.All"
            "Sites.FullControl.All"
            "Sites.Manage.All"
            "Sites.Read.All"
            "Sites.ReadWrite.All"
            "Sites.Selected"
            "SpiffeTrustDomain.Read.All"
            "SpiffeTrustDomain.ReadWrite.All"
            "Storyline.ReadWrite.All"
            "SubjectRightsRequest.Read.All"
            "SubjectRightsRequest.ReadWrite.All"
            "Synchronization.Read.All"
            "Synchronization.ReadWrite.All"
            "SynchronizationData-User.Upload"
            "SynchronizationData-User.Upload.OwnedBy"
            "Tasks.Read.All"
            "Tasks.ReadWrite.All"
            "Team.Create"
            "Team.ReadBasic.All"
            "TeamMember.Read.All"
            "TeamMember.ReadWrite.All"
            "TeamMember.ReadWriteNonOwnerRole.All"
            "TeamsActivity.Read.All"
            "TeamsActivity.Send"
            "TeamsAppInstallation.ManageSelectedForChat.All"
            "TeamsAppInstallation.ManageSelectedForTeam.All"
            "TeamsAppInstallation.ManageSelectedForUser.All"
            "TeamsAppInstallation.Read.All"
            "TeamsAppInstallation.ReadForChat.All"
            "TeamsAppInstallation.ReadForTeam.All"
            "TeamsAppInstallation.ReadForUser.All"
            "TeamsAppInstallation.ReadSelectedForChat.All"
            "TeamsAppInstallation.ReadSelectedForTeam.All"
            "TeamsAppInstallation.ReadSelectedForUser.All"
            "TeamsAppInstallation.ReadWriteAndConsentForChat.All"
            "TeamsAppInstallation.ReadWriteAndConsentForTeam.All"
            "TeamsAppInstallation.ReadWriteAndConsentForUser.All"
            "TeamsAppInstallation.ReadWriteAndConsentSelfForChat.All"
            "TeamsAppInstallation.ReadWriteAndConsentSelfForTeam.All"
            "TeamsAppInstallation.ReadWriteAndConsentSelfForUser.All"
            "TeamsAppInstallation.ReadWriteForChat.All"
            "TeamsAppInstallation.ReadWriteForTeam.All"
            "TeamsAppInstallation.ReadWriteForUser.All"
            "TeamsAppInstallation.ReadWriteSelectedForChat.All"
            "TeamsAppInstallation.ReadWriteSelectedForTeam.All"
            "TeamsAppInstallation.ReadWriteSelectedForUser.All"
            "TeamsAppInstallation.ReadWriteSelfForChat.All"
            "TeamsAppInstallation.ReadWriteSelfForTeam.All"
            "TeamsAppInstallation.ReadWriteSelfForUser.All"
            "TeamSettings.Read.All"
            "TeamSettings.ReadWrite.All"
            "TeamsPolicyUserAssign.ReadWrite.All"
            "TeamsResourceAccount.Read.All"
            "TeamsTab.Create"
            "TeamsTab.Read.All"
            "TeamsTab.ReadWrite.All"
            "TeamsTab.ReadWriteForChat.All"
            "TeamsTab.ReadWriteForTeam.All"
            "TeamsTab.ReadWriteForUser.All"
            "TeamsTab.ReadWriteSelfForChat.All"
            "TeamsTab.ReadWriteSelfForTeam.All"
            "TeamsTab.ReadWriteSelfForUser.All"
            "TeamsTelephoneNumber.Read.All"
            "TeamsTelephoneNumber.ReadWrite.All"
            "TeamsUserConfiguration.Read.All"
            "TeamTemplates.Read.All"
            "Teamwork.Migrate.All"
            "Teamwork.Read.All"
            "TeamworkAppSettings.Read.All"
            "TeamworkAppSettings.ReadWrite.All"
            "TeamworkDevice.Read.All"
            "TeamworkDevice.ReadWrite.All"
            "TeamworkTag.Read.All"
            "TeamworkTag.ReadWrite.All"
            "TermStore.Read.All"
            "TermStore.ReadWrite.All"
            "ThreatAssessment.Read.All"
            "ThreatHunting.Read.All"
            "ThreatIndicators.Read.All"
            "ThreatIndicators.ReadWrite.OwnedBy"
            "ThreatIntelligence.Read.All"
            "ThreatSubmission.Read.All"
            "ThreatSubmission.ReadWrite.All"
            "ThreatSubmissionPolicy.ReadWrite.All"
            "TrustFrameworkKeySet.Read.All"
            "TrustFrameworkKeySet.ReadWrite.All"
            "User-ConvertToInternal.ReadWrite.All"
            "User-LifeCycleInfo.Read.All"
            "User-LifeCycleInfo.ReadWrite.All"
            "User-Mail.ReadWrite.All"
            "User-PasswordProfile.ReadWrite.All"
            "User-Phone.ReadWrite.All"
            "User.DeleteRestore.All"
            "User.EnableDisableAccount.All"
            "User.Export.All"
            "User.Invite.All"
            "User.ManageIdentities.All"
            "User.Read.All"
            "User.ReadBasic.All"
            "User.ReadWrite.All"
            "User.ReadWrite.CrossCloud"
            "User.RevokeSessions.All"
            "UserAuthenticationMethod.Read.All"
            "UserAuthenticationMethod.ReadWrite.All"
            "UserAuthMethod-Passkey.Read.All"
            "UserAuthMethod-Passkey.ReadWrite.All"
            "UserNotification.ReadWrite.CreatedByApp"
            "UserShiftPreferences.Read.All"
            "UserShiftPreferences.ReadWrite.All"
            "UserTeamwork.Read.All"
            "VirtualAppointment.Read.All"
            "VirtualAppointment.ReadWrite.All"
            "VirtualAppointmentNotification.Send"
            "VirtualEvent.Read.All"
            "VirtualEventRegistration-Anon.ReadWrite.All"
            "WindowsUpdates.ReadWrite.All"
            "WorkforceIntegration.Read.All"
            "WorkforceIntegration.ReadWrite.All"
        )
        Return $PossibleScopes
    }
}


class SharePoint : System.Management.Automation.IValidateSetValuesGenerator {
    [System.String[]] GetValidValues() {
        $PossibleScopes = @(
            "Sites.ReadWrite.All"
            "Sites.Read.All"
            "Sites.FullControl.All"
            "Sites.Manage.All"
            "TermStore.Read.All"
            "TermStore.ReadWrite.All"
            "User.ReadWrite.All"
            "User.Read.All"
            "Sites.Selected"
        )
        Return $PossibleScopes
    }
}