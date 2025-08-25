<?php

namespace OPNsense\MosDNS;

use OPNsense\Base\IndexController as BaseIndexController;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class IndexController extends BaseIndexController
{
    public function indexAction()
    {
        $this->view->pick('OPNsense/MosDNS/index');
        
        // 加载所有需要的表单
        $this->view->generalForm = $this->getForm('general');
        $this->view->pluginsCacheForm = $this->getForm('plugins_cache');
        $this->view->pluginsFallbackForm = $this->getForm('plugins_fallback');
        $this->view->pluginsForwardForm = $this->getForm('plugins_forward');
        $this->view->pluginsHostsForm = $this->getForm('plugins_hosts');
        $this->view->pluginsIpsetForm = $this->getForm('plugins_ipset');
        $this->view->pluginsRedirectForm = $this->getForm('plugins_redirect');
        $this->view->pluginsSequenceForm = $this->getForm('plugins_sequence');
        $this->view->pluginsServersForm = $this->getForm('plugins_servers');
        $this->view->externalDataForm = $this->getForm('externaldata');
    }
}