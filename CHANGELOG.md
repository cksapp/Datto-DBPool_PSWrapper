# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.2.2] Release

Add 'Edit-DBPoolContainer', 'Set-DBPoolContainer' alias to `Rename-DBPoolContainer` function

Add 'Delete-DBPoolContainer', 'Destroy-DBPoolContainer' alias to `Remove-DBPoolContainer` function

Added `-UseBasicParsing` to IWR cmdlet to resolve Microsoft **KB5074596**

## [0.2.1]

Add 'Get-DBPool' alias to `Get-DBPoolContainer` function

Adjusted minor formatting in module and build

## [0.2.0] Release

Minor documentation updates, adds online help link for functions.

`Get-DBPoolUser` function outputs each user name passed directly to output stream rather than collecting all results and returning set

- Minor **BREAKING CHANGE** `Get-DBPoolUser` function now returns `apiKey` property as `[SecureString]`, with optional `-PlainTextAPIKey` switch

Default jsonDepth change to value '100' when `$DBPool_JSON_Conversion_Depth` not set and `-jsonDepth` parameter not passed

Adds function aliases to `New-DBPoolContainer`, now includes; 'Add-DBPoolContainer', 'Clone-DBPoolContainer', 'Copy-DBPoolContainer', 'Create-DBPoolContainer'

## [0.1.6] Unreleased

Majority small changes to docs. Minor bug fixes and additions to root module for development

`Get-DBPoolContainer` function now allows to get all **Status** from DBPool without needing to pass `-Id` parameter

## [0.1.5] BETA

GitHub pages using material theme for MKDocs. Module rename from 'Datto-DBPool_API' to 'Datto.DBPool.API'

Upated `Invoke-DBPoolContainerAction` function to use parallel processing if Ids parameter greater than 1

## [0.01.04] Unreleased

Updated with PsStucco Module build
