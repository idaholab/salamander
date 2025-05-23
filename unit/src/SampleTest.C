//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic confinement for Numerical Design, Engineering & Research,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
//* https://mooseframework.inl.gov/salamander
//*
//* SALAMANDER is powered by the MOOSE Framework
//* https://www.mooseframework.inl.gov
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
//*
//* Copyright 2025, Battelle Energy Alliance, LLC
//* ALL RIGHTS RESERVED
//*

#include "gtest/gtest.h"

TEST(MySampleTests, descriptiveTestName)
{
  // compare equality
  EXPECT_EQ(2, 1 + 1);
  EXPECT_DOUBLE_EQ(2 * 3.5, 1.0 * 8 - 1);

  // compare equality and immediately terminate this test if it fails
  // ASSERT_EQ(2, 1);

  // this won't run if you uncomment the above test because above assert will fail
  ASSERT_NO_THROW(1 + 1);

  // for a complete list of assertions and for more unit testing documentation see:
  // https://github.com/google/googletest/blob/master/googletest/docs/Primer.md
}

TEST(MySampleTests, anotherTest)
{
  EXPECT_LE(1, 2);
  // ...
}
