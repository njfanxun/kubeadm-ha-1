# Kubeadm HA

本项目使用`kubeadm`进行高可用kubernetes集群搭建，利用ansible-playbook实现自动化一键安装。

- 支持版本：

  |组件|支持|
  |:-|:-|
  |OS|Ubuntu 16.04+, Debian 9, CentOS/RedHat 7|
  |k8s|v1.12.4|
  |etcd|v3.2.4|
  |docker|17.03.3, 18.06.1|
  |network|flannel|

## 1. 环境准备

- 在执行ansible本脚本的机器上安装ansible运行需要的环境：
    - Ubuntu 16.04 请执行以下脚本：

        ``` bash
        # 文档中脚本默认均以root用户执行
        apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
        # 安装python2
        apt-get install python2.7
        # Ubuntu16.04可能需要配置以下软连接
        ln -s /usr/bin/python2.7 /usr/bin/python
        # 安装git和pip
        apt-get install git python-pip -y
        ```

    - CentOS 7 请执行以下脚本：

        ``` bash
        # 文档中脚本默认均以root用户执行
        # 安装 epel 源并更新
        yum install epel-release -y
        yum update
        # 安装python
        yum install python -y
        # 安装git和pip
        yum install git python-pip -y
        ```

    - 安装ansible
        
        ``` bash
        # pip安装ansible(国内如果安装太慢可以直接用pip阿里云加速)
        # pip install pip --upgrade
        # pip install ansible
        pip install pip --upgrade -i https://mirrors.aliyun.com/pypi/simple/
        
        pip install --no-cache-dir ansible -i https://mirrors.aliyun.com/pypi/simple/
        ```

- 可能出现的问题：

    - 在`Ubuntu 16.04`中，如果出现以下错误:

        ``` bash
        Traceback (most recent call last):
        File "/usr/bin/pip", line 9, in <module>
            from pip import main
        ImportError: cannot import name main
        ```
    - 将`/usr/bin/pip`做以下修改：

        ``` bash
        #原代码
        from pip import main
        if __name__ == '__main__':
            sys.exit(main())

        #修改后
        from pip import __main__
        if __name__ == '__main__':
            sys.exit(__main__._main())
        ```

## 2. 克隆本项目至ansible环境中：

```
git clone https://github.com/TimeBye/kubeadm-ha.git
```

## 3. 修改 hosts 文件

编辑项目`example`文件夹下的主机清单文件，修改各机器的访问地址、用户名、密码，并维护好各节点与角色的关系。文件中配置的用户必须是具有 **root** 权限的用户。项目预定义了6个例子，请修改后完成适合你的集群规划，生产环境建议一个节点只是一个角色。

- 搭建集群后有以下两种“样式”显示，请自行选择：
    - 样式一
        ```
        NAME             STATUS    ROLES                 AGE    VERSION
        192.168.56.11    Ready     etcd,master,worker    1d     v1.12.4
        192.168.56.12    Ready     etcd,master,worker    1d     v1.12.4
        192.168.56.13    Ready     etcd,master,worker    1d     v1.12.4
        ```

    - 样式二
        ```
        NAME     STATUS    ROLES                 AGE    VERSION
        node1    Ready     etcd,master,worker    1d     v1.12.4
        node2    Ready     etcd,master,worker    1d     v1.12.4
        node3    Ready     etcd,master,worker    1d     v1.12.4
        ```

    - 对应的hosts配置文件事例如下：

        |节点分配|样式一|样式二|
        |:-|:-|:-|
        |单节点|[hosts.allinone.ip](example/hosts.allinone.ip.ini)|[hosts.allinone.hostname](example/hosts.allinone.hostname.ini)|
        |单主多节点|[hosts.s-master.ip](example/hosts.s-master.ip.ini)|[hosts.s-master.hostname](example/hosts.s-master.hostname.ini)|
        |多主多节点|[hosts.m-master.ip](example/hosts.m-master.ip.ini)|[hosts.m-master.hostname](example/hosts.m-master.hostname.ini)|

## 4. 部署

进行安装:

- 基本配置执行
```
ansible-playbook -i example/hosts.allinone.ip.ini cluster.yaml
```

- 高级配置执行
```
ansible-playbook -i example/hosts.allinone.ip.ini -e @example/variables.yaml cluster.yaml
```

> 若`example/hosts.allinone.ip.ini`文件中与`example/variables.yaml`参数冲突，则以`example/variables.yaml`文件为准。

## 5. 重置

如果部署失败，想要重置集群(所有数据),执行：

```
ansible-playbook -i example/hosts.allinone.ip.ini reset.yml
```