<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\PluginTypes;

class IPSetController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'plugintypes';
    protected static $internalModelClass = 'OPNsense\MosDNS\PluginTypes';
    protected static $internalModelUseSafeDelete = true;

    /**
     * Search ipset plugins
     * @return array
     */
    public function searchIPSetAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('ipset.plugin');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('ipset.plugin', array('enabled', 'name', 'tag', 'type', 'args', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    /**
     * Get ipset plugin configurations
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $mdl = $this->getModel();
            $result['ipset'] = $mdl->ipset->getNodes();
        }
        return $result;
    }

    /**
     * Get specific ipset plugin by UUID (alias for getItemAction)
     * @param string $uuid item unique id
     * @return array
     */
    public function getIPSetAction($uuid = null)
    {
        return $this->getItemAction($uuid);
    }

    /**
     * Update ipset plugin by UUID (alias for setItemAction)
     * @param string $uuid item unique id
     * @return array
     */
    public function setIPSetAction($uuid = null)
    {
        return $this->setItemAction($uuid);
    }

    /**
     * Add new ipset plugin (alias for addItemAction)
     * @return array
     */
    public function addIPSetAction()
    {
        return $this->addItemAction();
    }

    /**
     * Delete ipset plugin by UUID (alias for delItemAction)
     * @param string $uuid item unique id
     * @return array
     */
    public function delIPSetAction($uuid = null)
    {
        return $this->delItemAction($uuid);
    }

    /**
     * Toggle ipset plugin enabled/disabled (alias for toggleItemAction)
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleIPSetAction($uuid = null)
    {
        return $this->toggleItemAction($uuid);
    }

    /**
     * Get specific ipset plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function getItemAction($uuid = null)
    {
        $mdl = $this->getModel();
        if ($uuid != null) {
            $node = $mdl->getNodeByReference('ipset.plugin.' . $uuid);
            if ($node != null) {
                return array('ipset' => $node->getNodes());
            }
        }
        return array();
    }

    /**
     * Add new ipset plugin
     * @return array
     */
    public function addItemAction()
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost()) {
            $mdl = $this->getModel();
            $node = $mdl->ipset->plugin->Add();
            $node->setNodes($this->request->getPost('ipset'));
            $valMsgs = $mdl->performValidation();
            if (count($valMsgs) == 0) {
                $mdl->serializeToConfig();
                $result['uuid'] = $node->getAttribute('uuid');
                $result['result'] = 'saved';
            } else {
                $result['validations'] = $valMsgs;
            }
        }
        return $result;
    }

    /**
     * Update ipset plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function setItemAction($uuid)
    {
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                $node = $mdl->getNodeByReference('ipset.plugin.' . $uuid);
                if ($node != null) {
                    $node->setNodes($this->request->getPost('ipset'));
                    $valMsgs = $mdl->performValidation();
                    if (count($valMsgs) == 0) {
                        $mdl->serializeToConfig();
                        return array('result' => 'saved');
                    } else {
                        return array('result' => 'failed', 'validations' => $valMsgs);
                    }
                }
            }
        }
        return array('result' => 'failed');
    }

    /**
     * Delete ipset plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function delItemAction($uuid)
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                if ($mdl->ipset->plugin->del($uuid)) {
                    $mdl->serializeToConfig();
                    $result['result'] = 'deleted';
                } else {
                    $result['result'] = 'not found';
                }
            }
        }
        return $result;
    }

    /**
     * Toggle ipset plugin enabled/disabled
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleItemAction($uuid)
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                $node = $mdl->getNodeByReference('ipset.plugin.' . $uuid);
                if ($node != null) {
                    if ($node->enabled->__toString() == '1') {
                        $node->enabled = '0';
                    } else {
                        $node->enabled = '1';
                    }
                    $valMsgs = $mdl->performValidation();
                    if (count($valMsgs) == 0) {
                        $mdl->serializeToConfig();
                        $result['result'] = 'saved';
                    } else {
                        $result['validations'] = $valMsgs;
                    }
                }
            }
        }
        return $result;
    }

    /**
     * Search ipset plugins
     * @return array
     */
    public function searchItemAction()
    {
        return $this->searchBase('ipset.plugin', array('enabled', 'tag', 'sets'));
    }
}