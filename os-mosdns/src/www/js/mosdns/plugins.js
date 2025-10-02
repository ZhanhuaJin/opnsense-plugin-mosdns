/*
 * Copyright (C) 2024 Deciso B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

$(document).ready(function() {
    var data_get_map = {'frm_GeneralSettings': "/api/mosdns/general/get"};

    // Load general settings
    mapDataToFormUI(data_get_map).done(function(data) {
        formatTokenizersUI();
        $('.selectpicker').selectpicker('refresh');
    });

    // Save general settings
    $("#saveAct").click(function() {
        saveFormToEndpoint(url="/api/mosdns/general/set", formid='frm_GeneralSettings', callback_ok=function() {
            $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                updateServiceControlUI('mosdns');
            });
        });
    });

    // Plugin management
    $("#pluginGrid").UIBootgrid({
        search: '/api/mosdns/plugin/searchPlugin',
        get: '/api/mosdns/plugin/getPlugin/',
        set: '/api/mosdns/plugin/setPlugin/',
        add: '/api/mosdns/plugin/addPlugin/',
        del: '/api/mosdns/plugin/delPlugin/',
        toggle: '/api/mosdns/plugin/togglePlugin/'
    });

    $("#addPluginBtn").click(function() {
        mapDataToFormDialog({}, 'dialogPlugin').done(function() {
            $('#dialogPlugin').modal('show');
        });
    });

    // Sequence management
    $("#sequenceGrid").UIBootgrid({
        search: '/api/mosdns/sequence/searchSequence',
        get: '/api/mosdns/sequence/getSequence/',
        set: '/api/mosdns/sequence/setSequence/',
        add: '/api/mosdns/sequence/addSequence/',
        del: '/api/mosdns/sequence/delSequence/',
        toggle: '/api/mosdns/sequence/toggleSequence/'
    });

    $("#addSequenceBtn").click(function() {
        mapDataToFormDialog({}, 'dialogSequence').done(function() {
            $('#dialogSequence').modal('show');
        });
    });

    // Sequence Rule management
    $("#sequenceRuleGrid").UIBootgrid({
        search: '/api/mosdns/sequence/searchRule',
        get: '/api/mosdns/sequence/getRule/',
        set: '/api/mosdns/sequence/setRule/',
        add: '/api/mosdns/sequence/addRule/',
        del: '/api/mosdns/sequence/delRule/',
        toggle: '/api/mosdns/sequence/toggleRule/'
    });

    $("#addSequenceRuleBtn").click(function() {
        mapDataToFormDialog({}, 'dialogSequenceRule').done(function() {
            $('#dialogSequenceRule').modal('show');
        });
    });

    // Update service status
    updateServiceControlUI('mosdns');
});