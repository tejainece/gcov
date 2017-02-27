	.file	"cond.c"
	.text
	.globl	_conditionalAdd
	.def	_conditionalAdd;	.scl	2;	.type	32;	.endef
_conditionalAdd:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	cmpl	$10, 8(%ebp)
	jbe	L2
	movl	___gcov0.conditionalAdd, %eax
	movl	___gcov0.conditionalAdd+4, %edx
	addl	$1, %eax
	adcl	$0, %edx
	movl	%eax, ___gcov0.conditionalAdd
	movl	%edx, ___gcov0.conditionalAdd+4
	cmpl	$19, 8(%ebp)
	ja	L2
	movl	12(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	jmp	L3
L2:
	movl	12(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	___gcov0.conditionalAdd+8, %eax
	movl	___gcov0.conditionalAdd+12, %edx
	addl	$1, %eax
	adcl	$0, %edx
	movl	%eax, ___gcov0.conditionalAdd+8
	movl	%edx, ___gcov0.conditionalAdd+12
L3:
	movl	-4(%ebp), %ecx
	movl	___gcov0.conditionalAdd+16, %eax
	movl	___gcov0.conditionalAdd+20, %edx
	addl	$1, %eax
	adcl	$0, %edx
	movl	%eax, ___gcov0.conditionalAdd+16
	movl	%edx, ___gcov0.conditionalAdd+20
	movl	%ecx, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
.lcomm ___gcov0.conditionalAdd,24,8
	.def	__GLOBAL__sub_I_65535_0_conditionalAdd;	.scl	3;	.type	32;	.endef
__GLOBAL__sub_I_65535_0_conditionalAdd:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$LPBX0, (%esp)
	call	___gcov_init
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.section	.ctors,"w"
	.align 4
	.long	__GLOBAL__sub_I_65535_0_conditionalAdd
	.data
	.align 4
___gcov_.conditionalAdd:
	.long	LPBX0
	.long	985948631
	.long	-1120628566
	.long	-1249818678
	.long	3
	.long	___gcov0.conditionalAdd
	.section .rdata,"dr"
	.align 4
LC0:
	.ascii "/cygdrive/c/Users/seragud/dart/gcov/test/data/condCov/cond.gcda\0"
	.data
	.align 32
LPBX0:
	.long	892351274
	.long	0
	.long	26312098
	.long	LC0
	.long	___gcov_merge_add
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	1
	.long	LPBX1
	.align 4
LPBX1:
	.long	___gcov_.conditionalAdd
	.ident	"GCC: (GNU) 5.3.0"
	.def	___gcov_init;	.scl	2;	.type	32;	.endef
	.def	___gcov_merge_add;	.scl	2;	.type	32;	.endef
