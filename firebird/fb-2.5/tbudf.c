#include <stdlib.h>
#include <stddef.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include <unac.h>

double udf_NVL(double *);
double udf_NVL(a)
double *a;
{
        if (a == NULL)
                return 0;
        else
                return *a;
}

double udf_RoundDec(double *, unsigned char *);
double udf_RoundDec(x, n)
double *x;
unsigned char *n;
{
        double pow_10 = pow(10.0f, (double)*n);
        return round(*x * pow_10) / pow_10;
}

int udf_Len(char *);
int udf_Len(s)
char *s;
{
        size_t len;
        len = strlen(s);
        return len;
}

double udf_Int(double *);
double udf_Int(a)
double *a;
{
        if (a == NULL)
                return 0;
        else
                return (int) *a;
}

char* udf_CollateBr(char *);
char* udf_CollateBr(s)
char *s;
{
        char* out = 0;

        unsigned int out_length = 0;

        //char* str = (char*)malloc(sizeof(char) * strlen(s));
        //memcpy (str, s, sizeof(char) * strlen(s));

        if(unac_string("ISO-8859-1", s, strlen(s), &out, &out_length)){
                //free(out);
                out = (char *)"ERRO UDF_COLLATEBR";
        }
        return out;
}
