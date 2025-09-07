<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class ServersController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'servers';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchServersAction()
    {
        return $this->searchBase('servers.servers', array('enabled', 'name', 'entry', 'listen', 'udp_or_tcp'));
    }

    public function getServersAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('servers', 'servers.servers', $uuid);
    }

    public function addServersAction()
    {
        return $this->addBase('servers', 'servers.servers');
    }

    public function delServersAction($uuid)
    {
        return $this->delBase('servers.servers', $uuid);
    }

    public function setServersAction($uuid)
    {
        return $this->setBase('servers', 'servers.servers', $uuid);
    }

    public function toggleServersAction($uuid)
    {
        return $this->toggleBase('servers.servers', $uuid);
    }
}