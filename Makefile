
CC=gcc
CPPFLAGS= -I./include -I/usr/include/fastdfs -I/usr/include/fastcommon -I/usr/local/include/hiredis
CFLAGS=-Wall 
LIBS= -lfdfsclient -lfastcommon -lhiredis

main=./main

hiredistest=./test/hiredistest

redis_op_test=./test/redis_op_test

file_uploaddfs_redis=./test/file_uploaddfs_redis

read_redis=./test/read_redis


target=$(main) $(hiredistest) $(redis_op_test) $(file_uploaddfs_redis) $(read_redis)


ALL:$(target)


#生成所有的.o文件
%.o:%.c
	$(CC) -c $< -o $@ $(CPPFLAGS) $(CFLAGS) 


#main程序
$(main):./main.o ./fdfs_api.o make_log.o
	$(CC) $^ -o $@ $(LIBS)

#hiredis程序
$(hiredistest):./test/hiredistest.o 
	$(CC) $^ -o $@ $(LIBS)

#redis_op_test程序
$(redis_op_test):./test/redis_op_test.o make_log.o ./test/redis_op.o 
	$(CC) $^ -o $@ $(LIBS)
	
#file_uploaddfs_redis程序
$(file_uploaddfs_redis):./test/file_uploaddfs_redis.o ./make_log.o ./fdfs_api.o ./test/redis_op.o 
	$(CC) $^ -o $@ $(LIBS)
	
	
#file_uploaddfs_redis程序
$(read_redis):./test/read_redis.o ./make_log.o ./fdfs_api.o ./test/redis_op.o 
	$(CC) $^ -o $@ $(LIBS)
#clean指令

clean:
	-rm -rf ./*.o $(target) ./test/*.o

distclean:
	-rm -rf ./*.o $(target) ./test/*.o

#将clean目标 改成一个虚拟符号
.PHONY: clean ALL distclean
