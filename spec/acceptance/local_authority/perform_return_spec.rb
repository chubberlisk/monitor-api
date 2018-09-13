# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Performing Return on HIF Project' do
  include_context 'use case factory'

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data[:data])
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end

  def create_new_return(return_data)
    get_use_case(:create_return).execute(return_data)[:id]
  end

  def expect_return_with_id_to_equal(id:, expected_return:)
    found_return = get_use_case(:get_return).execute(id: id)
    expect(found_return[:data]).to eq(expected_return[:data])
    expect(found_return[:status]).to eq(expected_return[:status])
    expect(found_return[:updates]).to eq(expected_return[:updates])
  end

  def expect_return_to_be_submitted(id:)
    found_return = get_use_case(:get_return).execute(id: id)
    expect(found_return[:status]).to eq('Submitted')
  end

  let(:project_baseline) do
    {
      summary: {
        BIDReference: '12345',
        projectName: 'Project name',
        leadAuthority: 'Made Tech',
        projectDescription: 'Descripion of project',
        noOfHousingSites: 10,
        totalArea: 10,
        hifFundingAmount: '10000',
        descriptionOfInfrastructure: 'An infrastructure',
        descriptionOfWiderProjectDeliverables: 'Wider infrastructure'
      },
      infrastructures: [
        {
          type: 'A House',
          description: 'A house of cats',

          outlinePlanningStatus: {
            granted: 'Yes',
            grantedReference: 'The Dogs',
            targetSubmission: '2020-01-01',
            targetGranted: '2020-01-01',
            summaryOfCriticalPath: 'Summary of critical path'
          },
          fullPlanningStatus: {
            granted: 'No',
            grantedReference: '1234',
            targetSubmission: '2020-01-01',
            targetGranted: '2020-01-01',
            summaryOfCriticalPath: 'Summary of critical path'
          },
          s106: {
            requirement: 'Yes',
            summaryOfRequirement: 'Required'
          },
          statutoryConsents: {
            anyConsents: 'Yes',
            detailsOfConsent: 'Details of consent',
            targetDateToBeMet: '2020-01-01'
          },
          landOwnership: {
            underControlOfLA: 'Yes',
            ownershipOfLandOtherThanLA: 'Dave',
            landAcquisitionRequired: 'Yes',
            howManySitesToAcquire: 10,
            toBeAcquiredBy: 'Dave',
            targetDateToAcquire: '2020-01-01',
            summaryOfCriticalPath: 'Summary of critical path',
            procurement: {
              contractorProcured: 'Yes',
              nameOfContractor: 'Dave',
              targetDateToAquire: '2020-01-01',
              summaryOfCriticalPath: 'Summary of critical path'
            }
          },
          milestones: [
            {
              descriptionOfMilestone: 'Milestone One',
              target: '2020-01-01',
              summaryOfCriticalPath: 'Summary of critical path'
            }
          ],
          expectedInfrastructureStart: {
            targetDateOfAchievingStart: '2020-01-01'
          },
          expectedInfrastructureCompletion: {
            targetDateOfAchievingCompletion: '2020-01-01'
          },
          risksToAchievingTimescales: [
            {
              descriptionOfRisk: 'Risk one',
              impactOfRisk: 'High',
              likelihoodOfRisk: 'High',
              mitigationOfRisk: 'Do not do the thing'
            }
          ]
        }
      ],
      financial: [
        {
          period: '2019/2020',
          instalments: [
            dateOfInstalment: '2020-01-01',
            instalmentAmount: '1000',
            baselineInstalments: [
              baselineInstalmentYear: '4000',
              baselineInstalmentQ1: '1000',
              baselineInstalmentQ2: '1000',
              baselineInstalmentQ3: '1000',
              baselineInstalmentQ4: '1000',
              baselineInstalmentTotal: '1000'
            ]
          ],
          costs: [
            {
              costOfInfrastructure: '1000',
              fundingStack: {
                totallyFundedThroughHIF: 'Yes',
                descriptionOfFundingStack: 'Stack',
                totalPublic: '2000',
                totalPrivate: '2000'
              }
            }
          ],
          baselineCashFlow: {
            summaryOfRequirement: 'data-url'
          },
          recovery: {
            aimToRecover: 'Yes',
            expectedAmountToRemove: 10,
            methodOfRecovery: 'Recovery method'
          }
        }
      ],
      s151: {
        s151FundingEndDate: '2020-01-01',
        s151ProjectLongstopDate: '2020-01-01'
      },
      outputsForecast: {
        totalUnits: 10,
        disposalStrategy: 'Disposal strategy',
        housingForecast: [
          {
            date: '2020-01-01',
            target: '2020-01-01',
            housingCompletions: '2020-01-01'
          }
        ]
      },
      outputsActuals: {
        siteOutputs: [
          siteName: 'Site name',
          siteLocalAuthority: 'Local Authority',
          siteNumberOfUnits: '123'
        ]
      }
    }
  end

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      type: 'hif', baseline: project_baseline
    )[:id]
  end

  let(:expected_base_return) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/base_return.json").read,
      symbolize_names: true
    )
  end

  let(:expected_second_base_return) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/second_base_return.json").read,
      symbolize_names: true
    )
  end

  before do
    project_id
  end

  it 'should keep track of Returns', :focus do
    base_return = get_use_case(:get_base_return).execute(project_id: project_id)
    pp "Real:"
    pp base_return[:base_return][:data]
    pp "Expected:"
    pp expected_base_return
    expect(base_return[:base_return][:data]).to eq(expected_base_return)

    initial_return = {
      project_id: project_id,
      data: {
        summary: {
          project_name: 'Cats Protection League',
          description: 'A new headquarters for all the Cats',
          lead_authority: 'Made Tech'
        },
        infrastructures: [
          {
            type: 'Cat Bathroom',
            description: 'Bathroom for Cats',
            completion_date: '2018-12-25',
            planning: {
              submission_estimated: '2018-06-01',
              submission_actual: '2018-07-01',
              submission_delay_reason: 'Planning office was closed for summer',
              planningNotGranted: {
                fieldOne: {
                  varianceCalculations: {
                    varianceAgainstLastReturn: {
                      varianceLastReturnFullPlanningPermissionSubmitted: nil
                    }
                  }
                }
              }
            }
          }
        ],
        financial: {
          total_amount_estimated: '£ 1000000.00',
          total_amount_actual: nil,
          total_amount_changed_reason: nil
        }
      }
    }

    return_id = create_new_return(
      project_id: initial_return[:project_id],
      data: initial_return[:data]
    )

    expected_initial_return = {
      project_id: project_id,
      status: 'Draft',
      updates: [
        initial_return[:data]
      ]
    }

    expect_return_with_id_to_equal(
      id: return_id,
      expected_return: expected_initial_return
    )

    updated_return_data = {
      summary: {
        project_name: 'Dogs Protection League',
        description: 'A new headquarters for all the Dogs',
        lead_authority: 'Made Tech'
      },
      infrastructures: [
        {
          type: 'Dog Bathroom',
          description: 'Bathroom for Dogs',
          completion_date: '2018-12-25',
          planning: {
            submission_estimated: '2018-06-01',
            submission_actual: '2018-07-01',
            submission_delay_reason: 'Planning office was closed for summer',
            planningNotGranted: {
              fieldOne: {
                varianceCalculations: {
                  varianceAgainstLastReturn: {
                    varianceLastReturnFullPlanningPermissionSubmitted: nil
                  }
                }
              }
            }
          }
        }
      ],
      funding: [
        {
          fundingPackages: [
            fundingPackage: {
              overview: {
                hifSpendSinceLastReturn: {
                  hifSpendCurrentReturn: '25565'
                }
              }
            }
          ]
        }
      ],
      financial: {
        total_amount_estimated: '£ 1000000.00',
        total_amount_actual: nil,
        total_amount_changed_reason: nil
      }
    }

    soft_update_return(id: return_id, data: updated_return_data)
    soft_update_return(id: return_id, data: updated_return_data)

    expected_updated_return = {
      project_id: project_id,
      status: 'Draft',
      updates: [
        initial_return[:data],
        updated_return_data,
        updated_return_data
      ]
    }

    expect_return_with_id_to_equal(
      id: return_id,
      expected_return: expected_updated_return
    )

    submit_return(id: return_id)
    expect_return_to_be_submitted(id: return_id)

    # A draft
    create_new_return(
      project_id: initial_return[:project_id],
      data: initial_return[:data]
    )

    second_base_return = get_use_case(:get_base_return).execute(project_id: project_id)
    expect(second_base_return[:base_return][:data]).to eq(expected_second_base_return)
  end

  def soft_update_return(id:, data:)
    get_use_case(:soft_update_return).execute(return_id: id, return_data: data)
  end

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data)
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end
end
