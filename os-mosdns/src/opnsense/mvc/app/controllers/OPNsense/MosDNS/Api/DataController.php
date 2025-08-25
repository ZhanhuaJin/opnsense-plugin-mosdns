<?php

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

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

/**
 * Class DataController
 * @package OPNsense\MosDNS\Api
 */
class DataController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    /**
     * Search data sources
     * @return array
     */
    public function searchDataSourceAction()
    {
        return $this->searchBase('datasources.datasource', array('enabled', 'name', 'url', 'backup_url', 'description'));
    }

    /**
     * Get data source details
     * @param string $uuid item unique id
     * @return array
     */
    public function getDataSourceAction($uuid = null)
    {
        return $this->getBase('datasource', 'datasources.datasource', $uuid);
    }

    /**
     * Add new data source
     * @return array
     */
    public function addDataSourceAction()
    {
        return $this->addBase('datasource', 'datasources.datasource');
    }

    /**
     * Update data source with given properties
     * @param string $uuid item unique id
     * @return array
     */
    public function setDataSourceAction($uuid)
    {
        return $this->setBase('datasource', 'datasources.datasource', $uuid);
    }

    /**
     * Delete data source by uuid
     * @param string $uuid item unique id
     * @return array
     */
    public function delDataSourceAction($uuid)
    {
        return $this->delBase('datasources.datasource', $uuid);
    }

    /**
     * Toggle data source by uuid (enable/disable)
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleDataSourceAction($uuid)
    {
        return $this->toggleBase('datasources.datasource', $uuid);
    }
}