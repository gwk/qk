// © 2015 George King. Permission to use this file is granted in license-qk.txt.


#define errFL(fmt, ...) fprintf(stderr, fmt "\n" ,##__VA_ARGS__)

#undef check
#define check(condition, ...) if (!(condition)) { errFL(__VA_ARGS__); abort(); }

#define malloc_safe(size) ({ \
size_t s = (size); \
void* ptr = malloc(s); \
check(ptr, "%s:%i: %s: malloc failed for size: %lu", __FILE__, __LINE__, __FUNCTION__, s); \
ptr; })
