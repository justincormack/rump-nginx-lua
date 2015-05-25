CC:=${RUMPRUN_CC}
ifeq (${CC},)
$(error set $$RUMPRUN_CC)
endif

all: bin/nginx

bin/nginx: nginx/objs/nginx
	mkdir -p bin
	cp $< $@

nginx/objs/nginx: nginx/Makefile
	$(MAKE) -C nginx

NGINX_CONF_ENV += \
	ngx_force_c_compiler=yes \
	ngx_force_c99_have_variadic_macros=yes \
	ngx_force_gcc_have_variadic_macros=yes \
	ngx_force_gcc_have_atomic=yes \
	ngx_force_have_libatomic=no \
	ngx_force_sys_nerr=100 \
	ngx_force_have_map_anon=yes \
	ngx_force_have_map_devzero=no \
	ngx_force_have_timer_event=yes \
	ngx_force_have_posix_sem=yes

NGINX_CONF_OPTS += \
	--crossbuild=NetBSD \
	--with-cc=${CC} \
	--prefix=/none \
	--conf-path=/data/conf/nginx.conf \
	--sbin-path=/none \
	--pid-path=/tmp/nginx.pid \
	--lock-path=/tmp/nginx.lock \
	--error-log-path=/tmp/error.log \
	--http-log-path=/tmp/access.log \
	--http-client-body-temp-path=/tmp/client-body \
	--http-proxy-temp-path=/tmp/proxy \
	--http-fastcgi-temp-path=/tmp/fastcgi \
	--http-scgi-temp-path=/tmp/scgi \
	--http-uwsgi-temp-path=/tmp/uwsgi \
	--with-ipv6 \
	--add-module=${DEVEL_KIT_PATH} \
	--add-module=${LUA_MOD_PATH} \
	--with-pcre=${PCRE_PATH}

nginx/Makefile: nginx/src
	(cd nginx; $(NGINX_CONF_ENV) ./configure $(NGINX_CONF_OPTS))

nginx/src:
	git submodule init
	git submodule update

.PHONY: clean
clean:
	$(MAKE) -C nginx clean
	rm -f bin/nginx
